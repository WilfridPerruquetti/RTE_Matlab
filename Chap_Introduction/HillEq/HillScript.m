clc;
clear;
%Load data set
O=[10 ; 15 ; 20 ; 25 ; 30 ; 40 ; 50 ; 100]; % O2
fb=[36 ; 56 ; 70 ; 79 ; 85 ; 91 ; 94 ; 99 ]/100; % Sat
% Plot data Sat versus O2
figure(1)
scatter(O,fb)
xlabel('mm. $\mathrm{O}_2$ tension','interpreter','latex')
ylabel('observed \% saturation','interpreter','latex')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figure1
cleanfigure;
matlab2tikz('Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);

% Linear regression
figure(2)
x=log(O);
y=log(fb./(1-fb));
scatter(x,y)
hold on
xlabel('$\log(x), x= \mathrm{O}_2$ tension','interpreter','latex')
ylabel('$\log\left(\frac{f_b}{1-f_b}\right)$','interpreter','latex')
% Compute the intercept
X = [ones(length(x),1) x];
InterceptSlope = X\y;
Kb=exp(InterceptSlope(1))
n=InterceptSlope(2)
% Generate the points of the line with intercept
Newy = X*InterceptSlope;
% Add this plot
plot(x,Newy,'r--')
legend('exp. data','linear approx. with intercept')
%saveas(gcf,'Figure.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figure2
cleanfigure;
matlab2tikz('Figure2.tex','width','\figwidth','height','\figheight','showInfo',false);
