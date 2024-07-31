%% Plot / Affichage
%time
t=out.time;
% input
u=out.control;
% continuous state
x1=out.state(:,1);
x2=out.state(:,2);
% discrete state
xkminus1=out.state(:,3);
xk=out.state(:,4);

figure('Name','Continuous state')
plot(t,x1,t,x2)
title('Continuous state','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
ylabel('$x_1,x_2$','Interpreter','latex')
legend('$x_1(t)$','$x_2(t)$','Interpreter','latex')
%saveas(gcf,'Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure1

cleanfigure;
matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);

figure('Name','Discrete state')
stairs(t,xkminus1)
hold on;
stairs(t,xk)
title('Discrete state','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
ylabel('$x_{k-1},x_k$','Interpreter','latex')
legend('$x_{k-1}(t)$','$x_k(t)$','Interpreter','latex')
%saveas(gcf,'Figure2.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure2

cleanfigure;
matlab2tikz('Figures/Figure2.tex','width','\figwidth','height','\figheight','showInfo',false);

figure('Name','Input')
plot(t,u)
title('Input','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
ylabel('$u$','Interpreter','latex')
legend('$u(t)$','Interpreter','latex')
%saveas(gcf,'Figure3.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure3

cleanfigure;
matlab2tikz('Figures/Figure3.tex','width','\figwidth','height','\figheight','showInfo',false);

