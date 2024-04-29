clear all;
close all;
clc;
load('/Users/perruquetti/Desktop/Calcul/MATLAB/Enseignement/Centrale/RTE/Book/Chap_Introduction/DCMotor/Data/ExpMotor.mat');
% Plot theta thetab versus time
figure(1);
plot(t,omega,'b',t,omegab,'r')
legend({'$\omega$ (blue)','$\omega$ Noisy (red)'},'Interpreter','latex','location','southeast');
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$\omega\, [rad s^{-1}]$','Interpreter','latex');
hold on;

Ts=mean(diff(t)); %2.5e-5
Nend=length(t); %16001
yss1=1.22;

i=1;
while omegab(i)<0.9*yss1 i=i+1;end;
N=i;

% rough estim k
k0=mean(omegab(N:Nend))/u0;
i=1;
while omegab(i)<0.5*yss1 i=i+1;end;
Nf=i;
% pseudo inverse
z=-log(1-omegab(1:Nf)/(k0*u0));
tau0=1/(t(1:Nf)\z(1:Nf));

%omega0+ku_0(1- \exp(-\frac{t}{\tau})).
modelfun = @(param,t)(param(1)*u0*(1-exp(-t*param(2))));

param0 = [k0, 1/tau0];
yest1=modelfun(param0,t);
plot(t,yest1)
legend({'$\omega$ (blue)','$\omega$ Noisy (red)','$\omega$ params 1 (yellow)'},'Interpreter','latex')
R20=1-sum((omegab - yest1).^2)/sum((omegab - mean(omegab)).^2);

disp(['1rst result: k=',num2str(k0),', tau=',num2str(tau0),',R2=',num2str(R20)]);

% Select data for fitting
t_fit = t;
f_fit = omegab;

InitialGuess=[0.5, 0.007];
R2=R20;
j=1;
% Nonlinear fit  
[param] = nlinfit(t_fit,f_fit,modelfun,InitialGuess);
yest2 = modelfun(param,t);
R2=1-sum((omegab - yest2).^2)/sum((omegab - mean(omegab)).^2);

k = param(1);
tau = 1/param(2);
% Plot Simulation using the obtained parameters
plot(t,yest2)
legend({'$\omega$ (blue)','$\omega$ Noisy (red)','$\omega$ params 1 (yellow)','$\omega$ params 2 (violet)'},'Interpreter','latex')
disp(['NLINFIT result: k=',num2str(k),', tau=',num2str(tau),',R2=',num2str(R2)]);


% Comparison between 3 datas sets
% experimental data 'b',
% simulated data with the obtained parameters 'r'
% simulated data with the chosen nominal parameters 'g'
figure;
plot(t,omegab,'r',t,yest1,'b',t,yest2,'g');
grid on;
legend('mesured value','simulated with param 1','simulated with param 2','location','southeast');
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$\omega$ [rad]','Interpreter','latex');

