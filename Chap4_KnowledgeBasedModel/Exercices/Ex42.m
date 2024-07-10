c1=0.2;
c2=0.05;
q1=20;
q2=5;
qs=25;
V=1000;
a=(c1*q1+c2*q2)/V
b=qs/V
c0=10/1000
salt=1000*a*(1-exp(-b*60))/b+c0*exp(-b*60)
t=0:0.1:60;
c=a*(1-exp(-b*t))/b+c0*exp(-b*t);

figure(1)
plot(t,c)
xlabel('$t\, [s]$','Interpreter','latex'), ylabel('$c(t)\, [kg\, l^{-1}]$','Interpreter','latex')
legend({'Solution $c(t)=\frac{a}{b} (1-\exp(-bt))+c(0)\exp(-bt)$'},'interpreter','latex','Location','southwest')

%saveas(gcf,'Figures/FigureEx42_1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureEx42_1

% cleanfigure;
% matlab2tikz('Figures/FigureEx42_1.tex','width','\figwidth','height','\figheight','showInfo',false);


V0=1000;
ap=(c1*q1+c2*q2)/V0
bp=(qs+1)/V0
salt=(V0+60)*ap*(1-exp(-bp*60))/bp+c0*exp(-bp*60)
t=0:0.1:60;
cp=ap*(1-exp(-bp*t))/bp+c0*exp(-bp*t);


figure(2)
plot(t,cp)
xlabel('$t\, [s]$','Interpreter','latex'), ylabel('$c(t)\, [kg\, l^{-1}]$','Interpreter','latex')
legend({'Solution $c(t)=\frac{a^\prime}{b^\prime} (1-\exp(-b^\prime t))+c(0)\exp(-b^\prime t)$'},'interpreter','latex','Location','southwest')

%saveas(gcf,'Figures/FigureEx42_2.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureEx42_2

% cleanfigure;
% matlab2tikz('Figures/FigureEx42_1.tex','width','\figwidth','height','\figheight','showInfo',false);
