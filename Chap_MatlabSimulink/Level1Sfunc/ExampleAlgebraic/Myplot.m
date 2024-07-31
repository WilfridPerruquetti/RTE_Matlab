%% Plot / Affichage
%time
t=out.time;
% input
u=out.control;
% discrete state
y=out.state.signals.values;

figure('Name','Output')
plot(t,y)

title('Output','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
ylabel('$y(t)=\sin(u_1)+ u_2^2$','Interpreter','latex')
legend('$y(t)$','Interpreter','latex')
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
legend('$u_1(t)$','$u_2(t)$','Interpreter','latex')
%saveas(gcf,'Figure3.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure1

cleanfigure;
matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);

