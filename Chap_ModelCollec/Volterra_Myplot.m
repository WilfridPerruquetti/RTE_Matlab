%% Simu
f = @(t,a) [a(1)-a(1)*a(2); -a(2)+a(1)*a(2)];
options = odeset('RelTol',1e-9,'AbsTol',1e-10);
% Simu 1
[ta,a] = ode45(f,[0 10],[1.3 1],options);
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
[tb,b] = ode45(f,[0 10],[1.6 1],options); 

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
[tc,c] = ode45(f,[0 10],[2 1],options);
[td,d] = ode45(f,[0 10],[2.5 1],options); 
[te,e] = ode45(f,[0 10],[3 1],options); 

%%%%%%%%%%%%%%%
%% Final Figure
%%%%
figure(5)
plot(a(:,1),a(:,2),b(:,1),b(:,2),c(:,1),c(:,2),d(:,1),d(:,2),e(:,1),e(:,2))
axis([-0.1 3.5 -0.1 3.5])
pbaspect([1 1 1])
xlabel('$x$','Interpreter','latex')
ylabel('$y$','Interpreter','latex')
title('$(x(t),y(t))$','Interpreter','latex')
legend({'$x(0)=1.3,y(0)=1$','$x(0)=1.6,y(0)=1$', '$x(0)=2,y(0)=1$','$x(0)=2.5,y(0)=1$','$x(0)=3,y(0)=1$'},'Interpreter','latex')

saveas(gcf,'Figures/Volterra.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Volterra

cleanfigure;
matlab2tikz('Figures/Volterra.tex','width','\figwidth','height','\figheight','showInfo',false);