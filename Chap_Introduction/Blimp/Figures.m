figure(1)
plot(t,z,t,u)
xlabel('$t$','Interpreter','latex')
ylabel('$z(t),u(t)$','Interpreter','latex')
legend('$z(t)$','$u(t)$','Interpreter','latex','Location','northwest')
%saveas(gcf,'Figure2.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figure

cleanfigure;
matlab2tikz('Figure.tex','width','\figwidth','height','\figheight','showInfo',false);
