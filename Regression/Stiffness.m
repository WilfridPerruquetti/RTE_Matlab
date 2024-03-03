clear all;
clc;
% true parameter
k=26;
% gravity
g=9.81;
% data
x =[1;1.18;1.2;1.44;1.6;1.8;2;2.08;2.28;2.7;2.88;3];% displacement
y=(k*x+10*rand(size(x)))/100;
mass=y/g;
% figure
figure(1)
scatter(x,y)
xlabel('Displacement $x$ [cm]','interpreter','latex')
ylabel('Weight $mg$ [kg m s$^{-2}$]','interpreter','latex')
hold on;
% LS estimation
kestm = x\y;
t=1:0.1:3;
y1=kestm*t;
plot(t,y1,'red')
legend({'Data','$y=k_{est}x,k_{est}=28$'},'interpreter','latex','Location','southeast')

saveas(gcf,'Figures/FigureStiff.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureStiff

cleanfigure;
matlab2tikz('Figures/FigureStiff.tex','width','\figwidth','height','\figheight','showInfo',false);