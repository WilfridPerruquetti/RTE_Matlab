clear all;
clc;
load('data.mat');
% Plot
figure(1)
plot(t,y,t,ynoisy);
disp('Looks like a 1rst order step response')

% y=ku_0(1-e^{-\frac{t}{\tau}})
modelfun = @(param,t)(param(1)*(1-exp(-param(2)*t)));

%% Linear regression
len=length(t);
ynoisy_final=ynoisy(len-50:len);
kestim=mean(ynoisy_final);
disp(['kestim=',num2str(kestim)]);
% z(t)=1/(1-y/(ku0))
u0=1;
T=0.25;% well choosen
pas=Ts;
W=round(T/pas);
trash=ynoisy(1:W)/(-kestim*u0);
z=abs(1./(1-trash));
lz=log(z);
figure(2)
plot(t(1:W),lz,'r')
slope = -t(1:W)'\lz;
tauestim=1/(slope);
disp(['tauestim=',num2str(tauestim)]);
param=[kestim;1/tauestim];
y_model=modelfun(param,t);
y_model=y_model';
residual1=sum((ynoisy - y_model).^2);
R2=1-residual1/sum((ynoisy - mean(ynoisy)).^2);
disp(['R2=',num2str(R2)]);
figure(3)
plot(t,ynoisy,t,y_model);

%% Nl regression
disp('Fiting not good enough=> NL Regression')
pas=Ts;
tinf= 0;
fitFirstDataInd=round(tinf/pas)+1;
tfin=2;
fitEndDataInd=round(tfin/pas);
% Select data for fitting
t_fit = t(fitFirstDataInd:fitEndDataInd) - t(fitFirstDataInd);
t_fit = t_fit';
f_fit = ynoisy(fitFirstDataInd:fitEndDataInd);
InitialGuess=[1.5985;2.65944];
% Nonlinear fit
[param,r,j] = nlinfit(t_fit,f_fit,modelfun,InitialGuess);
k = param(1);
tau = 1/param(2);
y = modelfun(param,t_fit);
figure(4)
plot(t_fit,f_fit,'b',t_fit,y,'r')
legend({'$y(t)$ Noisy (blue)','$\hat y(t)$ (red)'},'Interpreter','latex','Location','southeast');
xlabel('$t$ [s]','Interpreter','latex');
residual2=sum((f_fit - y).^2);
R2=1-residual2/sum((ynoisy - mean(ynoisy)).^2);
disp(['NLINFIT result:  kestim=',num2str(k),',  tau=',num2str(tau),',  Residual=',num2str(residual2),'  R2=',num2str(R2)]);



