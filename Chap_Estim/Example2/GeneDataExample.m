clc;
clear all;

%% Model
num=[1 1.8];
den=[1 0 1.2];
Mytf=tf(num,den);
roots(num);
roots(den);
Ts=0.1;
t=0:Ts:40;
t=t';
len1=length(t);

%% generate data step response
y=step(Mytf,t);
ynoisy=y+0.05*randn(len1,1);
save dataTemp.mat t Ts y ynoisy;
figure(1)
plot(t,y,t,ynoisy)

%% generate data frequency response
freq = logspace(-1,1,50);
len2=length(freq);
[mag,phase] = bode(tf([1 0.2],[1 2 1 1]),freq);
data = frd(mag.*exp(1j*phase*pi/180),freq);

noise=0.05*randn(len2,1);
for i=1:len2
    Mymag(i)=mag(:,:,i);
    MyPhase(i)=phase(:,:,i);
    if i<len2-5
        magNoisy(i)=mag(:,:,i)+noise(i);
        PhaseNoisy(i)=phase(:,:,i)+100*noise(i);
    else
        magNoisy(i)=mag(:,:,i);
        PhaseNoisy(i)=phase(:,:,i);
    end
end

dataNoisy = frd(magNoisy.*exp(1j*PhaseNoisy*pi/180),freq);
save dataFreq.mat data dataNoisy;

figure(2)
bodeplot(data,'ob');
hold on;
bodeplot(dataNoisy,'xr');

figure(3)
subplot(2,1,1)
grid on;
loglog(freq,Mymag)
hold on;
loglog(freq,magNoisy)

subplot(2,1,2)
grid on;
semilogx(freq,PhaseNoisy)
hold on;
semilogx(freq,PhaseNoisy)
