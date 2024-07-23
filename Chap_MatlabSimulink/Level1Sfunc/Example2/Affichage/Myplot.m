%% Plot / Affichage
%time
t=out.time;
l=length(t);
% input
u=out.control;
% continuous states
x1=out.state(:,1);
x2=out.state(:,2);
% discrete states
x1kminus1=out.state(:,3);
x1k=out.state(:,4);
x2kminus1=out.state(:,5);
x2k=out.state(:,6);

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
plot(t,x1kminus1,t,x1k,t,x2kminus1,t,x2k)
title('Discrete state','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
ylabel('$x_{1,k-1},x_{1,k},x_{2,k-1},x_{2,k}$','Interpreter','latex')
legend('$x_{1,k-1}(t)$','$x_{1,k}(t)$','$x_{2,k-1}$','$x_{2,k}$','Interpreter','latex')
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

