%% Simu
mu=0.7;
f = @(t,x) [x(2); mu*(1-x(1)^2)*x(2)-x(1)];
%
opts = odeset('Reltol',1e-13,'AbsTol',1e-14,'Stats','on');
% Simu 1
[ta,a] = ode45(f,[0 20],[0.1 0.1],opts);
[tb,b] = ode45(f,[0 10],[-1 0.1],opts); 
[tc,c] = ode45(f,[0 10],[2 2],opts);
[td,d] = ode45(f,[0 10],[-1 2],opts); 


%%%%%%%%%%%%
%% Figure
%%%%
figure(1)
plot(a(:,1),a(:,2),b(:,1),b(:,2),c(:,1),c(:,2),d(:,1),d(:,2))
axis([-2.5 2.5 -2.7 3.5])
pbaspect([1 1 1])
xlabel('$x_1$','Interpreter','latex')
ylabel('$x_2$','Interpreter','latex')
title('$(x(t),y(t))$','Interpreter','latex')
legend({'$x(0)=0.1,y(0)=0.1$','$x(0)=-1,y(0)=0.1$','$x(0)=2,y(0)=2$','$x(0)=-1,y(0)=2$'},'Interpreter','latex','Location','northwest')

saveas(gcf,'Figures/Figure.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure

cleanfigure;
matlab2tikz('Figures/Figure.tex','width','\figwidth','height','\figheight','showInfo',false);


% Second figure
[ta,a] = ode45(f,[0 40],[1.9465 -0.403595789388205],opts);

leng=length(ta);
window=6000;
tadebut=ta(leng-window)
tafin=ta(leng);
newa=a(leng-window:leng,:);
figure(2)
plot(newa(:,1),newa(:,2))
axis([-2.2 2.2 -2.5 2.5])
pbaspect([1 1 1])
xlabel('$x_1$','Interpreter','latex')
ylabel('$x_2$','Interpreter','latex')
title('Van der pol equations','Interpreter','latex')
%legend({'$x(0)=0.1,y(0)=0.1$','$x(0)=-1,y(0)=0.1$','$x(0)=2,y(0)=2$','$x(0)=-1,y(0)=2$'},'Interpreter','latex','Location','northwest')

%saveas(gcf,'Figures/Figure2.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure2

cleanfigure;
matlab2tikz('Figures/Figure2.tex','width','\figwidth','height','\figheight','showInfo',false);
