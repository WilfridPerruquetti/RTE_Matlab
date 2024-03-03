% Clear command window and workspace
clear;close all;clc;

% Read data
load('step_60.mat'); % load('step_100.mat'); % load('step_80.mat');% load('step_40.mat');

% Plot u,z versus time
figure;
plot(t,z,'b',t,u,'r');
legend('altitude','command');
xlabel('time(s)');

% Select data for fitting
t_fit = t(fitFirstDataInd:fitEndDataInd) - t(fitFirstDataInd);
f_fit = z(fitFirstDataInd:fitEndDataInd);

% Model used for fitting
z_0 = f_fit(1);
modelfun = @(param,t)(z_0 + K*param(2)*(exp(param(1)*t)/param(1)^2-1/param(1)^2-t/param(1)));

% Nonlinear fit
[param,r,j] = nlinfit(t_fit,f_fit,modelfun,[-1;1]);
a1 = param(1);
b = param(2);
disp(['NLINFIT result: a1=',num2str(a1),', b=',num2str(b)]);

% Simulation using the obtained parameters
z_sim = modelfun(param,t_fit);

% Nominal parameters selection
a1_nom = -0.28412; 
b_nom = 0.11214;
param_nom = [a1_nom, b_nom];

% Simulation using the nominal parameters
z_sim_nom = modelfun(param_nom,t_fit);

% Comparison between 3 datas sets
% experimental data 'b' (blue)
% simulated data with the obtained parameters 'r' (red)
% simulated data with the chosen nominal parameters 'g' (green)
figure;
plot(t_fit,z_sim,'r',t_fit,f_fit,'b',t_fit,z_sim_nom,'g');
grid on;
legend('simulated value with estimated param','mesured value','nominal model');
ylabel('Altitude(cm)');
xlabel('time(s)');



