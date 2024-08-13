clc;
clear all;
close all;
% params
global beta gamma N
beta = 0.3;  
gamma = 0.1;
N = 1000;
% init conditions
S0 = 999;  
I0 = 1;    
R0 = 0;
tspan = [0 160]; 

%% Simu
sir = @(t, y) [-beta*y(1)*y(2)/N ; beta*y(1)*y(2)/N-gamma*y(2); gamma*y(2)];
opts = odeset('Reltol',1e-6,'AbsTol',1e-5,'Stats','on');
[t,x] = ode45(sir,tspan, [S0 I0 R0],opts);

figure('Name','SIR')
title('SIR Model');
subplot(3,1,1)
plot(t,x(:,1),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$S$','Interpreter','latex')
legend('Susceptible: $S(t)$','Interpreter','latex','Location','best')
subplot(3,1,2)
plot(t,x(:,2),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$I$','Interpreter','latex')
legend('Infectious: $I(t)$','Interpreter','latex','Location','best')
subplot(3,1,3)
plot(t,x(:,3),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$R$','Interpreter','latex')
legend('Recovered: $R(t)$','Interpreter','latex','Location','best')

%saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureSIR

cleanfigure;
matlab2tikz('Figures/FigureSIR.tex','width','\figwidth','height','\figheight','showInfo',false);



