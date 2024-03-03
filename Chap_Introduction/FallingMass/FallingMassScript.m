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
% y=19.8x-0.182
% Or compute as follows
Slope = h\v2
% Generate the points of the line
V2Calc = Slope*h;
% Plot data and the line (passing through the origin)
plot(h,V2Calc,'b-')
% Compute the intercept
X = [ones(length(h),1) h];
NewSlope = X\v2
% Generate the points of the line with intercept
NewV2Calc = X*NewSlope;
% Add this plot
plot(h,NewV2Calc,'r--')
legend('exp. data','linear approx.','linear approx. with intercept')
%saveas(gcf,'Figure.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figure
cleanfigure;
matlab2tikz('Figure.tex','width','\figwidth','height','\figheight','showInfo',false);
