a=0.4;
xmax=10000;
d=600;
%% Simu
f = @(t,x) [a*x*(1-x/xmax)-d];
%
opts = odeset('Reltol',1e-13,'AbsTol',1e-14,'Stats','on');
% Simu 1
%[t,h] = ode45(f,[0 10],[600],opts);

% Simu 2
[t,h] = ode45(f,[0 200],[2000],opts);

figure('Name','Trouts')
plot(t,h,'b')
xlabel('$t$','Interpreter','latex')
ylabel('$x$ (Trouts)','Interpreter','latex')
legend('$x(t)$','Interpreter','latex')


set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureTrout1

cleanfigure;
matlab2tikz('FigureTrout1.tex','width','\figwidth','height','\figheight','showInfo',false);