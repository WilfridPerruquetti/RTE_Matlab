%% Plot / Affichage
%time
t=out.time;
% input
u=out.control;
% discrete state
x1=out.state.signals.values(:,1);
x2=out.state.signals.values(:,2);
x3=out.state.signals.values(:,3);
x4=out.state.signals.values(:,4);

figure('Name','Discrete state')
plot(t,x1,t,x2,t,x3,t,x4)

title('Continuous state','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
ylabel('$r(t),\dot r(t), \theta(t), \dot \theta(t)$','Interpreter','latex')
legend('$r(t)$','$\dot r(t)$','$\theta(t)$','$\dot \theta(t)$','Interpreter','latex','Location','best')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure

cleanfigure;
matlab2tikz('Figures/Figure.tex','width','\figwidth','height','\figheight','showInfo',false);

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
print -dpdf -painters Figures/Figure1

cleanfigure;
matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);

