clear all;
clc;
close all;
%% Simulink parameters
ti=0;
timef=200;
mysimu='ChemicalReactor';
open_system(mysimu);
set_param(mysimu,'Solver','ode45','StartTime','ti','StopTime','timef');

% Thermostat
% Equilibrium
Teq=100;
ueq=500;

poly=conv([1 1/30],conv([1 1/10],[1 1]));
a0=poly(4);
a1=poly(3);
a2=poly(2);
b=a0*Teq/ueq;

% Sampling
Ts=2;

% Controller
c1=-2.5;
c2=+2.2;
c3=0.8;

d=ueq*(1-c3)-Teq*(c1+c2);

Params=[a0;a1;a2;b;c1;c2;c3;d;Ts];

%% Launch simu
out = sim(mysimu, 'ReturnWorkspaceOutputs', 'on');
pause(3); 

%% Affichage
%time
t=out.time;
% input
u=out.control;
% dim state
a=size(out.state);
% discrete state
T=out.state(:,1);
dT=out.state(:,2);
d2T=out.state(:,3);
uk=out.state(:,4);
Tkminus1=out.state(:,5);

figure('Name','Continuous state')
plot(t,T,t,dT,t,d2T)
title('Continuous state','Interpreter','latex')
xlabel('$t\, [s]$','Interpreter','latex')
ylabel('$T(t),\frac{dT}{dt}(t),\frac{d^2T}{dt^2}(t)$','Interpreter','latex')
legend('$T(t)$','$\frac{dT}{dt}(t)$','$\frac{d^2T}{dt^2}(t)$','Interpreter','latex','Location','best')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureCont

cleanfigure;
matlab2tikz('FigureCont.tex','width','\figwidth','height','\figheight','showInfo',false);


figure('Name','Discrete state uk')
stairs(t,uk)

title('Discrete state','Interpreter','latex')
xlabel('$t\, [s], \quad T_s=1\, [s]$','Interpreter','latex')
ylabel('$u_k$','Interpreter','latex')
legend('$u_k$','Interpreter','latex','Location','best')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureDiscuk

cleanfigure;
matlab2tikz('FigureDiscuk.tex','width','\figwidth','height','\figheight','showInfo',false);


figure('Name','Discrete state Tkminus1')
stairs(t,Tkminus1)

title('Discrete state','Interpreter','latex')
xlabel('$t\, [s], \quad T_s=1\, [s]$','Interpreter','latex')
ylabel('$T_{k-1}$','Interpreter','latex')
legend('$T_{k-1}$','Interpreter','latex','Location','best')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureDiscTkminus1

cleanfigure;
matlab2tikz('FigureDiscTkminus1.tex','width','\figwidth','height','\figheight','showInfo',false);
