%% ODE
al=-1;
bl=-1;
f = @(t,x)[x(2); al*x(1)+bl*x(2)];

% Simu 1
[ta,a] = ode45(f,[0 10],[1 1]);
[tb,b] = ode45(f,[0 10],[-1 1]);
[tc,c] = ode45(f,[0 10],[-1 -1]); 
figure(1)
plot(a(:,1),a(:,2),'b',b(:,1),b(:,2),'m',c(:,1),c(:,2),'c')
xlabel('$x_1(t)$','Interpreter','latex')
ylabel('$x_2(t)$','Interpreter','latex')
legend('$(x_1(0)=1,x_2(0)=1)$','$(x_1(0)=-1,x_2(0)=1)$','$(x_1(0)=-1,x_2(0)=-1)$','Interpreter','latex')

saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure1

cleanfigure;
matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);

% Simu 2
al=-1;
bl=0.4;
f = @(t,x)[x(2); al*x(1)+bl*x(2)];
[ta,a] = ode45(f,[0 10],[1 1]);
[tb,b] = ode45(f,[0 10],[-1 1]);
[tc,c] = ode45(f,[0 10],[-1 -1]); 
figure(2)
plot(a(:,1),a(:,2),'b',b(:,1),b(:,2),'m',c(:,1),c(:,2),'c')
xlabel('$x_1(t)$','Interpreter','latex')
ylabel('$x_2(t)$','Interpreter','latex')
legend('$(x_1(0)=1,x_2(0)=1)$','$(x_1(0)=-1,x_2(0)=1)$','$(x_1(0)=-1,x_2(0)=-1)$','Interpreter','latex')

saveas(gcf,'Figures/Figure2.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure2

cleanfigure;
matlab2tikz('Figures/Figure2.tex','width','\figwidth','height','\figheight','showInfo',false);

% Simu 3
al=-1;
bl=0;
f = @(t,x)[x(2); al*x(1)+bl*x(2)];
[ta,a] = ode45(f,[0 10],[0.1 0.1]);
[tb,b] = ode45(f,[0 10],[0.5 0.5]);
[tc,c] = ode45(f,[0 10],[1 1]); 
figure(3)
plot(a(:,1),a(:,2),'b',b(:,1),b(:,2),'m',c(:,1),c(:,2),'c')
xlabel('$x_1(t)$','Interpreter','latex')
ylabel('$x_2(t)$','Interpreter','latex')
legend('$(x_1(0)=0.1,x_2(0)=0.1)$','$(x_1(0)=-1,x_2(0)=1)$','$(x_1(0)=-1,x_2(0)=-1)$','Interpreter','latex')

saveas(gcf,'Figures/Figure3.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure3

cleanfigure;
matlab2tikz('Figures/Figure3.tex','width','\figwidth','height','\figheight','showInfo',false);
