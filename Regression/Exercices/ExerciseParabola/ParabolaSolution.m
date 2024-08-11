clc;
clear all;
load('dataparabola.mat');
x=x';
y=y';
%least square
X= [ones(length(x),1) x (x.*x)];

%direct
theta0=inv(X'*X)*X'*y 

% Cholevski
[L]=chol(X'*X)
z=linsolve(L',X'*y)
thetaChol=linsolve(L,z)

% QR and backslash
[Q,R]=qr(X);
z=Q'*y;
thetaQR=linsolve(R,z)
thetaBackslash=X\y % backslash 

% SVD and pinv
[U,S,V] = svd(X,'econ');
thetaSVD = V*inv(S)*U'*y %SVD estim.
thetaPinv=pinv(X)*y %pinv
thetaRegress = regress(y,X)

% backslash 
theta=X\y;
a0=theta(1);
a1=theta(2);
a2=theta(3);

%plot
newx=linspace(-4,12,100);
newy=a0+a1*newx+a2*newx.*newx;

plot(x,y,"o",newx,newy,"-")
xlim([-5 9])
ylim([0 40])
grid on

legend({'Data','$y=a_0+a_1x+a_2x^2$'},'interpreter','latex','Location','best')

%saveas(gcf,'Figures/FigureParabola.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureParabola

cleanfigure;
matlab2tikz('Figures/FigureParabola.tex','width','\figwidth','height','\figheight','showInfo',false);

% filtered measurements
yf=a0+a1*x+a2*x.*x
% vector of residuals.
epsilon=y-yf
% R^2
Rsquare=1 - sum((y - yf).^2)/sum((y - mean(y)).^2)