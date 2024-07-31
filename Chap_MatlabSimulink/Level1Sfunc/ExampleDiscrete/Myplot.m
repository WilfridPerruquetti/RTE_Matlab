%% Plot / Affichage
%time
t=out.time;
newt=out.state.time;
% input
u=out.control;
% discrete state
uk=out.state.signals.values(:,1);
ykminus1=out.state.signals.values(:,2);
yk=out.state.signals.values(:,3);

figure('Name','Discrete state')
stairs(newt,uk);
hold on;
stairs(newt,ykminus1)
stairs(newt,yk)

title('Discrete state','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
ylabel('$u_k,y_{k-1},y_k$','Interpreter','latex')
legend('$u_k$','$y_{k-1}(t)$','$y_k(t)$','Interpreter','latex')
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

