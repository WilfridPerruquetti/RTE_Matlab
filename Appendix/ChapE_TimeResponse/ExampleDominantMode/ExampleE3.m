clear all;
clc;
close all;
% input
t = 0:0.01:10;
u = cos(2*t);


%% Compute solution
% Sol1
%yf1 = 1/5*exp(-t)*(1-1/5)-1/5*exp(-6*t)*(1-3/20)+ 1/100*cos(2*t) + 7/100*sin(2*t);
yf1 = -1/25*exp(-t)+1/100*exp(-6*t)+ 1/100*cos(2*t) + 7/100*sin(2*t);
% Sol2
%yf2 = 1/5*exp(-t)*(1-1/5)+1/100*cos(2*t) + 7/100*sin(2*t);
yf2 = -1/25*exp(-t)+1/100*cos(2*t) + 7/100*sin(2*t);

figure('Name','Time solution exact')
plot(t,yf1,t,yf2)
xlabel('$t$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend({'$y_{f}(t)$','$\tilde{y}_{f}(t)$'},'Interpreter','latex')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureDominantModeComp

cleanfigure;
matlab2tikz('FigureDominantModeComp.tex','width','\figwidth','height','\figheight','showInfo',false);


%% System response
% Sys 1
sys1 = tf([1],[1 7 6]);
y1=lsim(sys1,u,t);
% Sys 2
sys2 = tf([1/5*(1-1/5)],[1 1]);
y2=lsim(sys2,u,t);

f = @(t,x) [x(2); -7*x(2)-6*x(1)+cos(2*t)];
%
opts = odeset('Reltol',1e-6,'AbsTol',1e-4);
% Simu 1
[tau,x] = ode45(f,[0 10],[0 0],opts);
% x and y1 are exactly the same
figure('Name','Time response')
plot(t,y1,t,y2)%,t,y2,t,yf2,t,yf1,t,yf2
xlabel('$t$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend({'$y_1(t)$','$y_2(t)$'},'Interpreter','latex')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureDominantModeResp

cleanfigure;
matlab2tikz('FigureDominantModeResp.tex','width','\figwidth','height','\figheight','showInfo',false);

delay=0.15;
figure('Name','Time response')
plot(t,y1,t+delay,y2)%,t,y2,t,yf2,t,yf1,t,yf2
xlabel('$t$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend({'$y_f(t)$','$\tilde{y}_f(t)$','$y_1(t)$','$y_2(t)$'},'Interpreter','latex')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureDominantModeRespDelay

cleanfigure;
matlab2tikz('FigureDominantModeRespDelay.tex','width','\figwidth','height','\figheight','showInfo',false);


% Figure
figure('Name','Time solution')
plot(t,yf1,t,yf2,t,y1,t+delay,y2)%,t,y2,t,yf2,t,yf1,t,yf2
xlabel('$t$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend({'$y_f(t)$','$\tilde{y}_f(t)$','$y_1(t)$','$y_2(t)$'},'Interpreter','latex')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureDominantModeCompFinal

cleanfigure;
matlab2tikz('FigureDominantModeCompFinal.tex','width','\figwidth','height','\figheight','showInfo',false);