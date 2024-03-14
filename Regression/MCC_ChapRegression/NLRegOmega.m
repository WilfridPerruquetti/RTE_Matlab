clc;
clear all;
disp('Estimate the second ordre model parameters using NLfit from optimisation toolbox')

load ExpMotor.mat
% Plot omega omegab versus time
figure(1);
plot(t,omega,'b',t,omegab,'r')
legend({'$\omega$ (blue)','$\omega$  Noisy (red)'},'Interpreter','latex','Location','southeast');
xlabel('$t$ [s]','Interpreter','latex');

%New parametrization
z=exp(-t);
figure(2);
plot(z,omega,'b',z,omegab,'r')
legend({'$\omega$ (blue)','$\omega$  Noisy (red)'},'Interpreter','latex','Location','southeast');
xlabel('$z=exp(-t)$','Interpreter','latex');

% Use t and Nl reg
len=length(t);
pas=t(len)/len;
tinf= 0;
fitFirstDataInd=round(tinf/pas)+1; %2;
tfin=0.1;
fitEndDataInd=round(tfin/pas); %80;
% Select data for fitting
t_fit = t(fitFirstDataInd:fitEndDataInd) - t(fitFirstDataInd);
f_fit = omegab(fitFirstDataInd:fitEndDataInd);
modelfun = @(param,t)(param(1)*exp(-param(2)*t)+param(3)*u0*(1-exp(-param(2)*t)));
%\omega_0e^{-\frac{t}{\tau}}+ku_0(1-e^{-\frac{t}{\tau}})
InitialGuess=[0;1;0.6];
% Nonlinear fit
[param,r,j] = nlinfit(t_fit,f_fit,modelfun,InitialGuess);
omega0 = param(1);
tau = 1/param(2);
k = param(3);
y = modelfun(param,t_fit);
figure(3)
plot(t_fit,f_fit,'b',t_fit,y,'r')
legend({'$\omega$ Noisy (blue)','$\hat \omega$ (red)'},'Interpreter','latex','Location','southeast');
xlabel('$t$ [s]','Interpreter','latex');
residual1=sum((f_fit - y).^2);
disp(['NLINFIT result: omega0=',num2str(omega0),', tau=',num2str(tau),', k=',num2str(k),', Residual=',num2str(residual1)]);

% Use z and NL reg
z_fit=exp(-t_fit);
modelfun2 = @(param,z)(param(3)+(param(1)-param(3))*z.^param(2));
%k+(\omega_0-k)z^{\frac{1}{\tau}},
InitialGuess=[0;100;0.62];
% Nonlinear fit
[param2,r2,j2] = nlinfit(z_fit,f_fit,modelfun2,InitialGuess);
omega0 = param2(1);
tau = 1/param2(2);
k = param2(3);
y2 = modelfun2(param2,z_fit);
figure(3)
plot(z_fit,f_fit,'b',z_fit,y,'r')
legend({'$\omega$ Noisy (blue)','$\hat \omega$ (red)'},'Interpreter','latex','Location','southeast');
xlabel('$z=\exp(-t)$','Interpreter','latex');
residual2=sum((f_fit - y2).^2);

disp(['NLINFIT result: omega0=',num2str(omega0),', tau=',num2str(tau),', k=',num2str(k),', Residual=',num2str(residual2)]);