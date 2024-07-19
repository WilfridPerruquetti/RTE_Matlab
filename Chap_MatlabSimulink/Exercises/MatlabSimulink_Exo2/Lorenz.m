%% Simu
%\frac{\mathrm {d}  x}{\mathrm {d}  t}&=&\sigma(y-x)\\
%\frac{\mathrm {d}  y}{\mathrm {d}  t}&=&\rho x-y-xz\\
%\frac{\mathrm {d}  z}{\mathrm {d} t}&=&-\beta z+xy
fLorenz = @(t,x) [10*(x(2)-x(1)); 28*x(1)-x(2)-x(1)*x(3);-(8/3)*x(3)+x(1)*x(2)];
%
opts = odeset('Reltol',1e-13,'AbsTol',1e-14,'Stats','on');
% Simu 1
[t,x] = ode45(fLorenz,[0 10],[0.1 1 0.5],opts);

figure('Name','Lorenz')
subplot(3,1,1)
plot(t,x(:,1),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$x$','Interpreter','latex')
legend('$x(t)$','Interpreter','latex')
subplot(3,1,2)
plot(t,x(:,2),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend('$y(t)$','Interpreter','latex')
subplot(3,1,3)
plot(t,x(:,3),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$z$','Interpreter','latex')
legend('$z(t)$','Interpreter','latex')

%saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureLorenz1

cleanfigure;
matlab2tikz('Figures/FigureLorenz1.tex','width','\figwidth','height','\figheight','showInfo',false);

figure('Name','3DLorenz')
plot3(x(:,1),x(:,2),x(:,3),'b')
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
zlabel('$z$','Interpreter','latex')
legend('$(x(t),y(t),z(t)$','Interpreter','latex')

%saveas(gcf,'Figures/FigureLorenz2.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureLorenz2

cleanfigure;
matlab2tikz('Figures/FigureLorenz2.tex','width','\figwidth','height','\figheight','showInfo',false);
