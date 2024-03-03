%% Simu
sigma = 10;
beta = 8/3;
rho = 28;
f = @(t,a) [-sigma*a(1) + sigma*a(2); rho*a(1) - a(2) - a(1)*a(3); -beta*a(3) + a(1)*a(2)];

% Simu 1
[ta,a] = ode45(f,[0 10],[1 1 1]);
lena=length(ta);
figure(1)
subplot(3,1,1)
plot(ta,a(:,1),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$x$','Interpreter','latex')
legend('$x(t)$','Interpreter','latex')
subplot(3,1,2)
plot(ta,a(:,2),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend('$y(t)$','Interpreter','latex')
subplot(3,1,3)
plot(ta,a(:,3),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$z$','Interpreter','latex')
legend('$z(t)$','Interpreter','latex')

saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure1

cleanfigure;
matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);


figure(2)
plot3(a(:,1),a(:,2),a(:,3),'b')
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
zlabel('$z$','Interpreter','latex')
legend('$(x(t),y(t),z(t)$','Interpreter','latex')

saveas(gcf,'Figures/Figure2.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure2

cleanfigure;
matlab2tikz('Figures/Figure2.tex','width','\figwidth','height','\figheight','showInfo',false);

%Simu 2
b10=round(a(lena,1)*100)/100;
b20=round(a(lena,2)*100)/100;
b30=round(a(lena,3)*100)/100;
[tb,b] = ode45(f,[10 30],[b10 b20 b30]); 

figure(3)
subplot(3,1,1)
plot(tb,b(:,1),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$x$','Interpreter','latex')
legend('$x(t)$','Interpreter','latex')

subplot(3,1,2)
plot(tb,b(:,2),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend('$y(t)$','Interpreter','latex')
subplot(3,1,3)
plot(tb,b(:,3),'b')
xlabel('$t$','Interpreter','latex')
ylabel('$z$','Interpreter','latex')
legend('$z(t)$','Interpreter','latex')

saveas(gcf,'Figures/Figure3.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure3

cleanfigure;
matlab2tikz('Figures/Figure3.tex','width','\figwidth','height','\figheight','showInfo',false);


figure(4)
plot3(b(:,1),b(:,2),b(:,3),'b')
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
zlabel('$z$','Interpreter','latex')
legend('$(x(t),y(t),z(t)$','Interpreter','latex')

saveas(gcf,'Figures/Figure4.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure4

cleanfigure;
matlab2tikz('Figures/Figure4.tex','width','\figwidth','height','\figheight','showInfo',false);

%Simu 3
[tc,c] = ode45(f,[0 30],[1 1 1]); 

figure(5)
subplot(3,1,1)
plot(tc,c(:,1),'c')
xlabel('$t$','Interpreter','latex')
ylabel('$x$','Interpreter','latex')
legend('$x(t)$','Interpreter','latex')
subplot(3,1,2)
plot(tc,c(:,2),'c')
xlabel('$t$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend('$y(t)$','Interpreter','latex')
subplot(3,1,3)
plot(tc,c(:,3),'c')
xlabel('$t$','Interpreter','latex')
ylabel('$z$','Interpreter','latex')
legend('$z(t)$','Interpreter','latex')

saveas(gcf,'Figures/Figure5.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure5

cleanfigure;
matlab2tikz('Figures/Figure5.tex','width','\figwidth','height','\figheight','showInfo',false);


figure(6)
plot3(c(:,1),c(:,2),c(:,3),'c')
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
zlabel('$z$','Interpreter','latex')
legend('$(x(t),y(t),z(t)$','Interpreter','latex')

saveas(gcf,'Figures/Figure6.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure6

cleanfigure;
matlab2tikz('Figures/Figure6.tex','width','\figwidth','height','\figheight','showInfo',false);


%%%%%%%%%%%%%%%
%% Final Figure
%%%%
figure(7)
subplot(3,1,1)
plot(ta,a(:,1),'b',tb,b(:,1),'b',tc,c(:,1),'c')
xlabel('$t$','Interpreter','latex')
ylabel('$x$','Interpreter','latex')
legend('$x(t)$','Interpreter','latex')
subplot(3,1,2)
plot(ta,a(:,2),'b',tb,b(:,2),'b',tc,c(:,2),'c')
xlabel('$t$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
legend('$y(t)$','Interpreter','latex')
subplot(3,1,3)
plot(ta,a(:,3),'b',tb,b(:,3),'b',tc,c(:,3),'c')
xlabel('$t$','Interpreter','latex')
ylabel('$z$','Interpreter','latex')
legend('$z(t)$','Interpreter','latex')

saveas(gcf,'Figures/Figure7.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure7

cleanfigure;
matlab2tikz('Figures/Figure7.tex','width','\figwidth','height','\figheight','showInfo',false);


figure(8)
plot3(c(:,1),c(:,2),c(:,3))
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
zlabel('$z$','Interpreter','latex')
legend('$(x(t),y(t),z(t)$','Interpreter','latex')

saveas(gcf,'Figures/Figure8.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure8

cleanfigure;
matlab2tikz('Figures/Figure8.tex','width','\figwidth','height','\figheight','showInfo',false);