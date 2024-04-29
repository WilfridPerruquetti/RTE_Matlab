clear all;
clc;
%% Model Second order
%parameters
k=1.5;
z=1.5;
wn=2;
den=[1 2*z*wn wn*wn];
sys1=tf(k*wn*wn,den);
% real time constants values
ro=roots(den);
tau1_real=-1/ro(1);
tau2_real=-1/ro(2);

%% Step response
figure(1)
[ys,t]=step(sys1);
%r = a + (b-a).*rand(N,1).
Ampl=5e-2;
a=-1*Ampl;
b=1*Ampl;
addative_noise = a + (b-a)*rand(size(ys));
ys_noisy = ys+addative_noise;
%plot(t,ys)
plot(t,ys,t,ys_noisy)

ys=ys_noisy;
% Step response model (used for fitting)
% k = param(3);
% tau1 = param(1);
% tau2 = param(2);
modelfun = @(param,t) param(3)*(1-(param(1)*exp(-t/param(1))-param(2)*exp(-t/param(2)))/(param(1)-param(2)));

%% Parameters graphical estimation
% y25=1.5*0.25;%0.375
% t25=0.5717;
% y75=1.5*0.75;%1.125
% t75=2.0141;
% r=t25/t75;
% P=-18.56075*r+0.57311/(r-0.20747)+4.16423;
% Q=14.2797*r^3-9.3891*r^2+0.25437*r+1.32148;
% tau2=(t75-t25)/(Q*(1+1/P));
% tau1=tau2/P;
% disp(['Graphical estimation result: k=',num2str(k),', tau1=',num2str(tau1),', tau2=',num2str(tau2)]);
% paramestim1=[tau1;tau2;k];
% figure 1
%k
% u = [0.7 0.7];
% v = [0.8 0.92];
% annotation('textarrow',u,v,'String','$k$','interpreter','latex')
hold on
% t25=0.5717
% x=0:0.01:0.5717
% y=0.25*k*ones(size(x'));
% plot(x,y,'k')
% y=0:0.01:0.25*k
% x=0.5717*ones(size(y'));
% plot(x,y,'k')
% text(0.6717,0.25*k,'$t_{25}$','interpreter','latex');
%t75=2.0141
% x=0:0.01:2.0141
% y=0.75*k*ones(size(x'));
% plot(x,y,'k')
% y=0:0.01:0.75*k
% x=2.0141*ones(size(y'));
% plot(x,y,'k')
% text(2.1141,0.75*k,'$t_{75}$','interpreter','latex');
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
%yticks([0 0.1 0.2 0.375 0.5 1 1.125 1.5])
hLeg = legend('example')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters NoisyStep
cleanfigure;
matlab2tikz('NoisyStep.tex','width','\figwidth','height','\figheight','showInfo',false);

% Compare step response and the one from the estimated parameters
% figure(2)
% yestim1=modelfun(paramestim1,t);
% R2estim1=1 - sum((ys - yestim1).^2)/sum((y - mean(y)).^2);
% disp(['R^2 (estim1)=',num2str(R2estim1)]);
% % R2=0.99987 very good !
% plot(t,yestim1,'r',t,ys,'k')
% % plot error estimation 1e-3
% figure(3)
% plot(t,yestim1-ys,'k')
% % plot error estimation 1e-15
% figure(4)
% paramreal=[tau1_real;tau2_real;k];
% ytheo=modelfun(paramreal,t);
% plot(t,ytheo-ys,'k')

%% Estimation using regression
len=length(ys);
% k estimation
kest=mean(ys(len-100:len));
% select time intervalle for regression (first time constant)
z=-log(1-ys/kest);
ndeb=70;
nfin=250;
% plot data over selected time window
figure(5)
plot(t(ndeb:nfin),z(ndeb:nfin))
% estimate tau1
tau1est=t(ndeb:nfin)\z(ndeb:nfin);
ytau1est=exp(-t/tau1est); % 0.7161 not very good
alpha=1.2;
ynew=(1-ys/kest+alpha*ytau1est)/(1+alpha);
z2=-log(ynew);
figure(6)
plot(t,z2)
% select time intervalle for regression
ndeb=40;
nfin=150;
plot(t(ndeb:nfin),z2(ndeb:nfin))
tau2est=t(ndeb:nfin)\z2(ndeb:nfin);
% estimated response
paramestim2=[tau1est;tau2est;kest];
yestim2= modelfun(paramestim2,t);;
figure(7)
plot(t,ys-yestim2)
R2estim2=1 - sum((ys - yestim2).^2)/sum((ys - mean(ys)).^2);
disp(['R^2 (estim2)=',num2str(R2estim2)]);
%R2 = 0.96851 very good
figure(8)
plot(t,ys,'k',t,yestim2,'c')

%% Nonlinear regression
% Select data for fitting
fitFirstDataInd=1;
fitEndDataInd=600;
t_fit = t(fitFirstDataInd:fitEndDataInd);
f_fit = ys(fitFirstDataInd:fitEndDataInd);
% Initial guess of params
param0=paramestim2;
% Nonlinear fit
[param,r,j] = nlinfit(t_fit,f_fit,modelfun,param0);
k = param(3);
tau1 = param(1);
tau2 = param(2);
disp(['NLINFIT result: k=',num2str(k),', tau1=',num2str(tau1),', tau2=',num2str(tau2)]);
% Simulation using the obtained parameters
y_sim = modelfun(param,t);
plot(t,ys,t,y_sim)
R2estim3=1 - sum((ys - y_sim).^2)/sum((ys - mean(ys)).^2);
disp(['R^2=',num2str(R2estim3)]);
% R2=1 extra !


