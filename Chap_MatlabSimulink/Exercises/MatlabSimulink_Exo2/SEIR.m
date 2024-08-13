clc;
clear all;
close all;
% params
global beta gamma Mysigma N
beta = 0.3; 
Mysigma = 0.2;
gamma = 0.1;
N = 1000;
% init conditions
S0 = 999;  
E0 = 0;    
I0 = 1;    
R0 = 0;
tspan = [0 160]; 

%% Simu
seir = @(t, y) [-beta*y(1)*y(3)/N ; beta*y(1)*y(3)/N-Mysigma*y(2);Mysigma*y(2)- gamma*y(3);gamma*y(3)];
opts = odeset('Reltol',1e-6,'AbsTol',1e-5,'Stats','on');
[t,y] = ode45(seir,tspan, [S0 E0 I0 R0],opts);

figure('Name','SEIR')
title('SEIR Model');
plot(t, y(:,1), 'b', t, y(:,2), 'y', t, y(:,3), 'r', t, y(:,4), 'g');
xlabel('$t$','Interpreter','latex')
ylabel('$S(t),E(t),I(t),R(t)$','Interpreter','latex')
legend('Susceptible $S$','Exposed $E$', 'Infected $I$', 'Recovered $R$','Interpreter','latex','Location','best')

%saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureSEIR

cleanfigure;
matlab2tikz('Figures/FigureSEIR.tex','width','\figwidth','height','\figheight','showInfo',false);
