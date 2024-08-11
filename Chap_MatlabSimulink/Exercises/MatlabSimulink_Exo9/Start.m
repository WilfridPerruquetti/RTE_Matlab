clear all;
clc;
close all;
%% Simulink parameters
ti=0;
timef=100;
mysimu='HybridTheromstatHeating';
open_system(mysimu);
set_param(mysimu,'Solver','ode45','StartTime','ti','StopTime','timef');

%  Thermostat
C=500;
k=50;
P=1000;
Tamb=10;
Tlow=21;
Thigh=23;

Params=[C;k;P;Tamb;Tlow;Thigh];

%% Launch simu
out = sim(mysimu, 'ReturnWorkspaceOutputs', 'on');
pause(3); 

%% Affichage
%time
t=out.time;
% input
u=out.control;
% continuous state
T=out.state(:,1);
% discrete state
uk=out.state(:,2);

figure('Name','Continuous state')
plot(t,T)
title('Continuous state','Interpreter','latex')
xlabel('$t\, [s]$','Interpreter','latex')
ylabel('$T(t)$','Interpreter','latex')
legend('$T(t)$','Interpreter','latex','Location','best')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureCont

cleanfigure;
matlab2tikz('FigureCont.tex','width','\figwidth','height','\figheight','showInfo',false);



figure('Name','Discrete state')
stairs(t,uk)
ylim([-0.5 1.2])

title('Discrete state','Interpreter','latex')
xlabel('$t\, [s]$','Interpreter','latex')
ylabel('$u_{k}$','Interpreter','latex')
legend('$u_{k}$','Interpreter','latex','Location','south')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureDisc

cleanfigure;
matlab2tikz('FigureDisc.tex','width','\figwidth','height','\figheight','showInfo',false);


