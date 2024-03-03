clc;
clear;
%Load data set
FallingMass;
% compute v^2
v2=v.^2;
% Plot data v2 versus h
figure(1)
scatter(h,v2)
xlabel('initial height $h$ [m]','interpreter','latex')
ylabel('squared final velocity $v^2 [m^2s^{-2}]$','interpreter','latex')
hold on
% Use Tools-> Basic fitting -> linear
% y=xx
% Or compute as follows
Slope = h\v2
% Generate the points of the line
V2Calc = Slope*h;
% Plot data and the line (passing through the origin)
plot(h,V2Calc,'b-')
%saveas(gcf,'Figure.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figure1
cleanfigure;
matlab2tikz('Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);
