%%%%%%%%%%%%%%%
%% Final Figure
%%%%

step=0.2;
figure(1)
for eps=0:step:1
    tspan1 = -5:step:-eps;
    sol1=-(tspan1+eps).^2/4;
    tspan2 = -eps:step:eps;
    sol2=0*tspan2;
    tspan3 = eps:step:5;
    sol3=(tspan3-eps).^2/4;
    plot(tspan1,sol1,tspan2,sol2,tspan3,sol3)
hold on
end;
axis([-5 5 -6.2 6.2])
pbaspect([1 1 1])
xlabel('$t$','Interpreter','latex')
ylabel('$x(t)$','Interpreter','latex')
title('$x(t)$ solution of $\frac{\mathrm{d}x}{\mathrm{d}t} =\left| x\right| ^{\frac{1}{2}},x(0)=0$','Interpreter','latex')
legend({'$\varepsilon=0$','$\varepsilon=0.2$','$\varepsilon=0.4$','$\varepsilon=0.6$','$\varepsilon=0.8$','$\varepsilon=1$'},'Interpreter','latex','Location','northwest')

saveas(gcf,'Figures/Figure.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure

cleanfigure;
matlab2tikz('Figures/Figure.tex','width','\figwidth','height','\figheight','showInfo',false);