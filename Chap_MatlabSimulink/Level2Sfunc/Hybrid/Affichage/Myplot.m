%% Plot / Affichage
t=out.time;
l=length(t);

x1=out.state(:,1);
x2=out.state(:,2);



figure(1)
plot(t(1:finsimu),x1(1:finsimu),t(1:finsimu),x2(1:finsimu),t(1:finsimu),x3(1:finsimu))
xlabel('$t$','Interpreter','latex')
ylabel('$x_1,x_2,h_3$','Interpreter','latex')
legend('$h_1(t)$','$h_2(t)$','$h_3(t)$','Interpreter','latex')
%saveas(gcf,'Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure1

cleanfigure;
matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);

figure(3)
plot(t(1:finsimu),u1(1:finsimu),t(1:finsimu),u2(1:finsimu))
xlabel('$t$','Interpreter','latex')
ylabel('$q_e$','Interpreter','latex')
legend('$q_{e1}(t)$','$q_{e2}(t)$','Interpreter','latex')
%saveas(gcf,'Figure3.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure3

cleanfigure;
matlab2tikz('Figures/Figure3.tex','width','\figwidth','height','\figheight','showInfo',false);



