clear all;
clc;
close all;

% Simulink parameters
ti=0;
tf=3;
% Sampling period
Ts = 0.005;
% Define the polynomial P(tau)
P = @(tau) 2 - 3 * tau;
% Define the polynomial Q(tau, t, T)
Q = @(tau, t, T) -60 * (7*t^2 - 14*t*tau + 7*tau.^2 + t*T - T*tau - 2*T^2);

%% Compute and plot I1
N=round(tf/Ts);
% Parameters for S-functions
ParamI1.Ts=Ts;
ParamI1.P=P;
ParamI1.N=N;

mysimu='SimuOnlineComputeI1Level2';
open_system(mysimu);
set_param(mysimu,'StartTime','ti','StopTime','tf');
% Launch simu
out = sim(mysimu, 'ReturnWorkspaceOutputs', 'on');
pause(3); 
% Affichage
%time
t=out.time;
% input
u=out.control;
% continuous state
I1=out.Integral1;

figure('Name','Integral I1')
plot(t,I1)
title('Continuous state','Interpreter','latex')
xlabel('$t\, [s]$','Interpreter','latex')
ylabel('$I_1(t)$','Interpreter','latex')
legend('$I_1(t)$','Interpreter','latex','Location','best')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureSimuOnlineI1

cleanfigure;
matlab2tikz('Figures/FigureSimuOnlineI1.tex','width','\figwidth','height','\figheight','showInfo',false);


%% Compute and plot I2
% Time window length T
T = 0.1;
k=4;
ParamI2.T=T;
ParamI2.Ts=Ts;
ParamI2.k=k;
ParamI2.Q=Q;

mysimu='SimuOnlineComputeI2Level2';
open_system(mysimu);
set_param(mysimu,'StartTime','ti','StopTime','tf');
% Launch simu
out = sim(mysimu, 'ReturnWorkspaceOutputs', 'on');
pause(3); 
% Affichage
%time
t=out.time;
% input
u=out.control;
% continuous state
I2=out.Integral2;

%Plot the results
figure('Name','Integral I2');
plot(t_values, I2_values, 'r-', 'LineWidth', 0.5);
title('$I_2(y,t,T)$ vs $t$','Interpreter','latex');
xlabel('$t [s]$','Interpreter','latex');
ylabel('$I_2(y,t,T)$','Interpreter','latex');
legend('$I_2(y,t,T)$','Interpreter','latex','Location','best')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureSimuOnlineI2

cleanfigure;
matlab2tikz('Figures/FigureSimuOnlineI2.tex','width','\figwidth','height','\figheight','showInfo',false);