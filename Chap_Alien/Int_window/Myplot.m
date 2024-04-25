t=out.t;
y=out.y;
a=out.a;
figure(1)
plot(t,y)
xlabel('$t$','Interpreter','latex')
ylabel('$y(t)$','Interpreter','latex')
%legend('$(x_1(0)=1,x_2(0)=1)$','$(x_1(0)=-1,x_2(0)=1)$','$(x_1(0)=-1,x_2(0)=-1)$','Interpreter','latex')

%saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure1

cleanfigure;
matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);

figure(2)
plot(t,a)
xlabel('$t$','Interpreter','latex')
ylabel('$a(t)$','Interpreter','latex')
%legend('$(x_1(0)=1,x_2(0)=1)$','$(x_1(0)=-1,x_2(0)=1)$','$(x_1(0)=-1,x_2(0)=-1)$','Interpreter','latex')

saveas(gcf,'Figures/Figure2.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure2

cleanfigure;
matlab2tikz('Figures/Figure2.tex','width','\figwidth','height','\figheight','showInfo',false);
