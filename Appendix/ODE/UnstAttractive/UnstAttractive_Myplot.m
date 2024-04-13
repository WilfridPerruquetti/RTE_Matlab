%% Simu
mu=0.7;
f = @(t,x) [x(1)*(1-sqrt(x(1)^2+x(2)^2))-(1-x(1)/(sqrt(x(1)^2+x(2)^2)))*x(2)/2; 
    x(2)*(1-sqrt(x(1)^2+x(2)^2))+(1-x(1)/(sqrt(x(1)^2+x(2)^2)))*x(1)/2];
%
opts = odeset('Reltol',1e-13,'AbsTol',1e-14,'Stats','on');
% Simu 1
[ta,a] = ode45(f,[0 70],[0.1 0.1],opts);
[tb,b] = ode45(f,[0 120],[1.001 0.05],opts); 
[tc,c] = ode45(f,[0 70],[1.1 1.1],opts);
[td,d] = ode45(f,[0 70],[-1 1.15],opts); 


%%%%%%%%%%%%
%% Figure
%%%%%%%%%%%%
xm=1.2;
ym=1.2;
deltax=xm;
deltay=ym;
figure(1)
f1=[0.8500, 0.3250, 0.0980];
arrowPlot(a(:,1),a(:,2),'number', 5, 'color', f1, 'LineWidth', 1, 'scale', 0.8, 'ratio', 'equal');
axis([-xm xm -ym ym])
hold on
f2=[0, 0.4470, 0.7410];
arrowPlot(b(:,1),b(:,2),'number', 5, 'color', f2, 'LineWidth', 1, 'scale', 0.8, 'ratio', 'equal');
hold on
f3=[0.9290, 0.6940, 0.1250];
arrowPlot(c(:,1),c(:,2),'number', 5, 'color', f3, 'LineWidth', 1, 'scale', 0.8, 'ratio', 'equal');
hold on
f4=[0.5 0.7 0.1];
arrowPlot(d(:,1),d(:,2),'number', 5, 'color', f4, 'LineWidth', 1, 'scale', 0.8, 'ratio', 'equal');
pbaspect([1 1 1])
xlabel('$x(t)$','Interpreter','latex')
ylabel('$y(t)$','Interpreter','latex')
%title('$(x(t),y(t))$','Interpreter','latex')
%legend({'$x(0)=0.1,y(0)=0.1$','$x(0)=-1,y(0)=0.1$','$x(0)=2,y(0)=2$','$x(0)=-1,y(0)=2$'},'Interpreter','latex','Location','northwest')
hLeg = legend('example')
set(hLeg,'visible','off')

saveas(gcf,'Figures/Figure.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure

cleanfigure;
matlab2tikz('Figures/Figure.tex','width','\figwidth','height','\figheight','showInfo',false);

