%% Plot / Affichage
%time
t=out.time;
newt=out.state.time;
% input
u=out.control.signals.values;
% continuous state
x1=out.state.signals.values(:,1);
x2=out.state.signals.values(:,2);
% discrete state
uk=out.state.signals.values(:,3);
ykminus1=out.state.signals.values(:,4);
yk=out.state.signals.values(:,5);


figure('Name','Continuous states')
plot(t,x1,t,x2)

title('Continuous state','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
ylabel('$x_1(t),x_2(t)$','Interpreter','latex')
legend('$x_1(t)$','$x_2(t)$','Interpreter','latex')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure1

cleanfigure;
matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);



figure('Name','Discrete states')
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

