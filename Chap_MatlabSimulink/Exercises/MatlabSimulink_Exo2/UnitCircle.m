%% Simu
f = @(t,a) [(1-a(1)*a(1)-a(2)*a(2))*a(1)-a(2); a(1)+(1-a(1)*a(1)-a(2)*a(2))*a(2)];
%
opts = odeset('Reltol',1e-13,'AbsTol',1e-14,'Stats','on');
% Simu 1
[ta,a] = ode45(f,[0 10],[0.1 0.5],opts);

figure('Name','Unit Circle')
subplot(2,1,1)
plot(ta,a(:,1),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$x$','Interpreter','latex')
legend('$x(t)$','Interpreter','latex')
subplot(2,1,2)
plot(ta,a(:,2),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend('$y(t)$','Interpreter','latex')

%saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureUnitCircle1

cleanfigure;
matlab2tikz('Figures/FigureUnitCircle1.tex','width','\figwidth','height','\figheight','showInfo',false);

figure('Name','Phase portrait Unit Circle')
plot(a(:,1),a(:,2),'b')
pbaspect([1 1 1])
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend('$y(x)$','Interpreter','latex')

%saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureUnitCircle2

cleanfigure;
matlab2tikz('Figures/FigureUnitCircle2.tex','width','\figwidth','height','\figheight','showInfo',false);
