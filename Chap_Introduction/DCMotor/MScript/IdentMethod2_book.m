theta=States(:,1);
thetab=NoisyStates(:,1);
% Plot theta thetab versus time
figure(1);
plot(t,theta,'b',t,thetab,'r')
legend({'$\theta$ (blue)','$\theta$ Noisy (red)'},'Interpreter','latex');
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$\theta$ [rad]','Interpreter','latex');
% select the time window (data for estimation)
len=length(t);pas=t(len)/len;
tinf=0;
fitFirstDataInd=round(tinf/pas)+1; %1
tfin=0.2;
fitEndDataInd=round(tfin/pas); %8000
% Select data for fitting
t_fit = t(fitFirstDataInd:fitEndDataInd)- t(fitFirstDataInd);
f_fit = thetab(fitFirstDataInd:fitEndDataInd);
%\theta(0)+ ku_0 \left(t+\tau \left(\exp\left(-\frac{t}{\tau}\right)-1\right)\right).
modelfun = @(param,t)(param(1)+param(2)*u0*(t+param(3)*(exp(-t/param(3))-1)));
InitialGuess=[1;0.6;0.008];
% Nonlinear fit
[param,r,j] = nlinfit(t_fit,f_fit,modelfun,InitialGuess);
y0 = param(1);
k = param(2);
tau = param(3);
disp(['NLINFIT result: y0=',num2str(y0),', k=',num2str(k),', tau=',num2str(tau)]);
% Simulation using the obtained parameters
theta_sim = modelfun(param,t_fit);

% Nominal parameters selection
y0_nom = 1;
k_nom = 0.62;
tau_nom=0.008;
param_nom = [y0_nom, k_nom, tau_nom];
theta_sim_nom = modelfun(param_nom,t_fit);

% Comparison between 3 datas sets
% experimental data 'b',
% simulated data with the obtained parameters 'r'
% simulated data with the chosen nominal parameters 'g'
figure;
plot(t_fit,theta_sim,'r',t_fit,f_fit,'b',t_fit,theta_sim_nom,'g');
grid on;
legend('simulated value with estimated param','mesured value','nominal model');
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$\theta$ [rad]','Interpreter','latex');

