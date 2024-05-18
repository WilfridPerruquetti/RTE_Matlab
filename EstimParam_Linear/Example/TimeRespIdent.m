clc;
clear all;

%% Nominal model
num=[1 2];
den=[1 2 1.1 1];
Mytf=tf(num,den);

%% Data
load dataTemp;
figure(1)
plot(t,y,t,ynoisy)
hold on;

%% Graphical method
len1=length(t);
window=20;
% estim k
ynoisy_final=ynoisy(len1-window:len1);
kestim=mean(ynoisy_final);
disp(['kestim=',num2str(kestim)]);

% overshoot
t1=4.2;
n1=round(t1/Ts);
t2=12.6;
n2=round(t2/Ts);

M=(y(n1)-kestim)/kestim;
zetaestim=-log(M)/sqrt(pi^2+log(M)^2);
disp(['zetaestim=',num2str(zetaestim)]);
Tp=t2-t1;
omeganestim=(2*pi)/(Tp*sqrt(1-zetaestim^2));
disp(['omeganestim=',num2str(omeganestim)]);

numMod1=kestim*omeganestim*omeganestim;
denMod1=[1 2*zetaestim*omeganestim omeganestim*omeganestim];

sysMod1=tf(numMod1,denMod1);
[yMod1]=step(sysMod1,t);
residual1=sum((ynoisy - yMod1).^2);
R2=1-residual1/sum((ynoisy - mean(ynoisy)).^2);
disp(['R2=',num2str(R2)]);

plot(t,yMod1)

%% Using Sysid
u=ones(len1,1);
Data = iddata(ynoisy,u,Ts);
get(Data);
% select data for identif
% window ident
window=len1;
DataIdent = Data(1:window); % Select range for data 
figure(2)
plot(DataIdent);
%DataIdent = detrend(DataIdent);
figure(3)
plot(DataIdent);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estimate models parameters  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% state spasce model parameter estimation
m1 = ssest(DataIdent,3) % select dimension of state (here 2)
[num1,den1]=ss2tf(m1.A,m1.B,m1.C,m1.D);
tf1=tf(num1,den1);
% arx model parameter estimation
m2 = arx(DataIdent,[3 2 0]) % select orders (here 3 2 and no delay)
tf2=d2c(m2,'zoh');
% transfert function parameter estimation
m3 = tfest(DataIdent, 3, 2, 0, 'Ts', Ts) % select np=2,nz=1,iodelay=0 discrete model using Ts
m3c=d2c(m3,'zoh');
tf3=tf(m3c.Numerator,m3c.Denominator) % from transfert function obtain new state space model parameters
% pem
opt = n4sidOptions('Focus','simulation');
init_sys = n4sid(DataIdent,3,opt); 
init_sys.Report.Fit.FitPercent; % very small fit 2% with initial model
m4 = pem(DataIdent,init_sys,'Display','on','SearchMethod','lm'); 
[num4,den4]=ss2tf(m4.A,m4.B,m4.C,m4.D);
tf4=tf(num4,den4);
%Validating the Estimated Model to Experimental Output
figure(4)
compare(DataIdent,m1,m2,m3,m4);
set(gcf,'DefaultLegendLocation','best')







