clc;
clear;
%Load data set
load accidents
% Look at hwyheaders
% Column 5: Licensed Drivers (thousands)
% Column 14: Population of states
x = hwydata(:,14); 
% Column 4: Number of fatal accidents per year for the considered state (Traffic fatalities)
y = hwydata(:,4); 
format short
% Slope computation
beta1 = x\y
% Generate the points of the line
yCalc1 = beta1*x;
% Plot data and the line (passing through the origin)
scatter(x,y)
hold on
plot(x,yCalc1)
xlabel('Population of state')
ylabel('Fatal traffic accidents per state')
title('Linear Regression Relation Between Accidents & Population')
grid on
% Compute the intercept
X = [ones(length(x),1) x];
beta = X\y
beta0=beta(1)
beta1=beta(2)
% Generate the points of the line with intercept
yCalc2 = X*beta;
% Add this plot
plot(x,yCalc2,'--')
legend('Data','Slope','Slope & Intercept','Location','best');
% Which line is better ?
Rsq1 = 1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2)
Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2)
% Which state is the most distant form the regression line
e=0;
state=0;
max=0;
for i=1:51 
    e=abs(y(i)-x(i)*beta1-beta0);
    if e>max max=e;state=i; else end;
end
state