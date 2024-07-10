%\ell \ddot{\theta}+g\sin(\theta)=0. 
%\ell=0.1
%% Simu
f = @(t,x) [x(2);(-9.81*sin(x(1)))/0.1];
%
opts = odeset('Reltol',1e-13,'AbsTol',1e-14,'Stats','on');
% Simu 1
[t,x] = ode45(f,[0 10],[0.1 0.5],opts);

figure('Name','Pendulum')
subplot(2,1,1)
plot(t,x(:,1),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$x$','Interpreter','latex')
legend('$x(t)$','Interpreter','latex')
subplot(2,1,2)
plot(t,x(:,2),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$\dot x(t)$','Interpreter','latex')
legend('$\dot x(t)$','Interpreter','latex')

%saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigurePendulum1

cleanfigure;
matlab2tikz('Figures/FigurePendulum1.tex','width','\figwidth','height','\figheight','showInfo',false);

figure('Name','Phase portrait Pendulum')
plot(x(:,1),x(:,2),'b')
pbaspect([1 1 1])
xlabel('$x(t)$','Interpreter','latex')
ylabel('$y=\dot x(t)$','Interpreter','latex')
legend('$y(x)$','Interpreter','latex')

%saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigurePendulum2

cleanfigure;
matlab2tikz('Figures/FigurePendulum2.tex','width','\figwidth','height','\figheight','showInfo',false);
