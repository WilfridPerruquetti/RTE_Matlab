%% Simu
f = @(t,a) [(1-a(1)*a(1)-a(2)*a(2))*a(1)-a(2); a(1)+(1-a(1)*a(1)-a(2)*a(2))*a(2)];
%
opts = odeset('Reltol',1e-13,'AbsTol',1e-14,'Stats','on');
% Simu 1
[ta,a] = ode45(f,[0 10],[0.1 0.5],opts);
lena=length(ta);
% figure(1)
% subplot(2,1,1)
% plot(ta,a(:,1),'b')
% xlabel('$t$','Interpreter','latex')
% ylabel('$x$','Interpreter','latex')
% legend('$x(t)$','Interpreter','latex')
% subplot(2,1,2)
% plot(ta,a(:,2),'b')
% xlabel('$t$','Interpreter','latex')
% ylabel('$y$','Interpreter','latex')
% legend('$y(t)$','Interpreter','latex')
% 
% saveas(gcf,'Figures/Figure1.pdf')
% set(gcf,'Units','centimeters');
% screenposition = get(gcf,'Position');
% set(gcf,...
%     'PaperPosition',[0 0 screenposition(3:4)],...
%     'PaperSize',[screenposition(3:4)]);
% print -dpdf -painters Figures/Figure1
% 
% cleanfigure;
% matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);
% 
% 
% figure(2)
% plot(a(:,1),a(:,2),'b')
% pbaspect([1 1 1])
% xlabel('$x$','Interpreter','latex')
% ylabel('$y$','Interpreter','latex')
% legend('$(x(t),y(t))$','Interpreter','latex')
% 
% saveas(gcf,'Figures/Figure2.pdf')
% set(gcf,'Units','centimeters');
% screenposition = get(gcf,'Position');
% set(gcf,...
%     'PaperPosition',[0 0 screenposition(3:4)],...
%     'PaperSize',[screenposition(3:4)]);
% print -dpdf -painters Figures/Figure2
% 
% cleanfigure;
% matlab2tikz('Figures/Figure2.tex','width','\figwidth','height','\figheight','showInfo',false);
% 
% Simu 2
[tb,b] = ode45(f,[0 10],[1 1.5],opts); 

% figure(3)
% subplot(2,1,1)
% plot(tb,b(:,1),'b')
% xlabel('$t$','Interpreter','latex')
% ylabel('$x$','Interpreter','latex')
% legend('$x(t)$','Interpreter','latex')
% 
% subplot(2,1,2)
% plot(tb,b(:,2),'b')
% xlabel('$t$','Interpreter','latex')
% ylabel('$y$','Interpreter','latex')
% legend('$y(t)$','Interpreter','latex')
% 
% saveas(gcf,'Figures/Figure3.pdf')
% set(gcf,'Units','centimeters');
% screenposition = get(gcf,'Position');
% set(gcf,...
%     'PaperPosition',[0 0 screenposition(3:4)],...
%     'PaperSize',[screenposition(3:4)]);
% print -dpdf -painters Figures/Figure3
% 
% cleanfigure;
% matlab2tikz('Figures/Figure3.tex','width','\figwidth','height','\figheight','showInfo',false);
% 
% 
% figure(4)
% plot(b(:,1),b(:,2),'b')
% pbaspect([1 1 1])
% xlabel('$x$','Interpreter','latex')
% ylabel('$y$','Interpreter','latex')
% legend('$(x(t),y(t))$','Interpreter','latex')
% 
% saveas(gcf,'Figures/Figure4.pdf')
% set(gcf,'Units','centimeters');
% screenposition = get(gcf,'Position');
% set(gcf,...
%     'PaperPosition',[0 0 screenposition(3:4)],...
%     'PaperSize',[screenposition(3:4)]);
% print -dpdf -painters Figures/Figure4
% 
% cleanfigure;
% matlab2tikz('Figures/Figure4.tex','width','\figwidth','height','\figheight','showInfo',false);


%%%%%%%%%%%%%%%
%% Final Figure
%%%%
%figure(5)
plot(a(:,1),a(:,2),'color','r');
hold on;
plot(b(:,1),b(:,2),'color', 'blue');
hold on;
legend('$x(0)=0.1,y(0)=0.5$','$x(0)=1,y(0)=1.5$','Interpreter','latex','Location','northwest')
axis([-1.5 1.5 -1.5 1.5])
pbaspect([1 1 1])
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
title('$(x(t),y(t))$','Interpreter','latex')
L = legend;
L.AutoUpdate = 'off'; 
arrowPlot(a(:,1),a(:,2),'number', 4, 'color', 'r');
hold on;
arrowPlot(b(:,1),b(:,2),'number', 4, 'color', 'blue');

saveas(gcf,'Figures/Figure5.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure5

cleanfigure;
matlab2tikz('Figures/Figure5.tex','width','\figwidth','height','\figheight','showInfo',false);