clear all;
clc;
x=5;
n=1000;
% data
nu=ones(n,1);
t=1:n;
for i=1:n
nu(i)=-1+2*rand;
end;
y=x+nu;
mymean=mean(y)
% figure
figure(1)
scatter(t,y)
xlabel('$n$','interpreter','latex')
ylabel('$y$','interpreter','latex')
hold on;
tt=1:0.01:n;
plot(tt,mymean*ones(length(tt),1))
legend({'Data','Mean'},'interpreter','latex','Location','southeast')

saveas(gcf,'Figures/FigureMean1000.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureMean1000

cleanfigure;
matlab2tikz('Figures/FigureMean1000.tex','width','\figwidth','height','\figheight','showInfo',false);