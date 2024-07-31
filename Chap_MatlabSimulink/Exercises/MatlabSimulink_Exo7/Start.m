clear all;
clc;
close all;
%% Simulink parameters
ti=0;
timef=5;
mysimu='HybridMobileRobot';
open_system(mysimu);
set_param(mysimu,'Solver','ode45','StartTime','ti','StopTime','timef');

%  Robot
m = 1; % Mass
b = 0.5; % Damping coefficient
k = 1; % Spring constant

% Sampling
Ts=0.5;

% Controller
%tr=2.9/w
z=0.7;
w=30;
num=w*w;
den=[1 2*z*w w*w];
syscont=tf(num,den);
sysdisc=c2d(syscont,Ts);
Numdisc=sysdisc.Numerator;
Dendisc=sysdisc.Denominator;

a0=Dendisc{1,1}(3);
a1=Dendisc{1,1}(2);

Kp=2;
Kd=0.3;

b1 = Numdisc{1,1}(1)*Kp; b0 = Numdisc{1,1}(2)*Kp;
c1 = Numdisc{1,1}(1)*Kd; c0 = Numdisc{1,1}(2)*Kd;

Params=[m;b;k;a0;a1;b0;b1;c0;c1];

% %% Launch simu
% out = sim(mysimu, 'ReturnWorkspaceOutputs', 'on');
% pause(3); 
% 
% %% Affichage
% %time
% t=0:0.2:tf;
% % input
% u=out.control;
% % dim state
% a=size(out.state);
% % discrete state
% x=out.state(:,1);
% v=out.state(:,2);
% un_minus_1=out.state(:,3);
% un=out.state(:,4);
% 
% figure('Name','Continuous state')
% plot(t,x,t,v)
% title('Continuous state','Interpreter','latex')
% xlabel('$t\, [s]$','Interpreter','latex')
% ylabel('$x(t),v(t)=\frac{ds}{dt}(t)$','Interpreter','latex')
% legend('$x(t)$','$v(t)=\frac{ds}{dt}(t)','Interpreter','latex','Location','best')
% 
% figure('Name','Discrete state')
% stairs(t,un_minus_1)
% hold on
% stairs(t,un)
% hold on
% 
% title('Discrete state','Interpreter','latex')
% xlabel('$t\, [s], \quad T_s=0.5\, [s]$','Interpreter','latex')
% ylabel('$u_{n-1},u_n$','Interpreter','latex')
% legend('$u_{n-1}$','$u_n$','Interpreter','latex','Location','best')
% 
% set(gcf,'Units','centimeters');
% screenposition = get(gcf,'Position');
% set(gcf,...
%     'PaperPosition',[0 0 screenposition(3:4)],...
%     'PaperSize',[screenposition(3:4)]);
% print -dpdf -painters FigureDiscretePredatorPrey
% 
% cleanfigure;
% matlab2tikz('FigureDiscretePredatorPrey.tex','width','\figwidth','height','\figheight','showInfo',false);
% 

