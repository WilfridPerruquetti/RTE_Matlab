clc;
clear all;
load('datacircle.mat');
%least square
C=[2*x,2*y,ones(100,1)];
z=x.^2+y.^2;
theta=C\z;
a=theta(1)
b=theta(2)
R=sqrt(theta(3)+a^2+b^2)

%plot
t=linspace(0,2*pi,100);
plot(x,y,"o",a+R*cos(t),b+R*sin(t),"-")
xlim([-5 3])
ylim([-2 6])
grid on
daspect([1 1 1])

legend({'Data','$(x-a)^2+(y-b)^2=R^2$'},'interpreter','latex','Location','southwest')

saveas(gcf,'Figures/FigureCircle.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureCircle

cleanfigure;
matlab2tikz('Figures/FigureCircle.tex','width','\figwidth','height','\figheight','showInfo',false);