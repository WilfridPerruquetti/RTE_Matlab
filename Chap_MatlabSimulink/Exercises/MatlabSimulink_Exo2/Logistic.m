%\dot{x}=ax\left(1-\frac{x}{x_{\max}}\right),a>0,
% a=1,x_{\max}=100

%% Simu
f = @(t,x) [1*x*(1-x/100)];
%
opts = odeset('Reltol',1e-13,'AbsTol',1e-14,'Stats','on');
% Simu 1
[t,h] = ode45(f,[0 10],[0.4],opts);

figure('Name','Variable Section Tank')
plot(t,h,'b')
xlabel('$t$','Interpreter','latex')
ylabel('$x$','Interpreter','latex')
legend('$x(t)$','Interpreter','latex','Location','best')

%saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureLogistic

cleanfigure;
matlab2tikz('Figures/FigureLogistic.tex','width','\figwidth','height','\figheight','showInfo',false);