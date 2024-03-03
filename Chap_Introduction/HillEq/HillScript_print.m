clc; clear;
%Load data set
O=[10 ; 15 ; 20 ; 25 ; 30 ; 40 ; 50 ; 100]; % O2
fb=[36 ; 56 ; 70 ; 79 ; 85 ; 91 ; 94 ; 99 ]/100; % Sat
% Plot data Sat versus O2
figure(1)
scatter(O,fb)
xlabel('mm. $\mathrm{O}_2$ tension','interpreter','latex')
ylabel('observed \% saturation','interpreter','latex')

%%%%%%%%%%%%%%%%%%%%%%%
%% Linear regression %%
%%%%%%%%%%%%%%%%%%%%%%%
% Compute the intercept
x=log(O);
y=log(fb./(1-fb));
X = [ones(length(x),1) x];
InterceptSlope = X\y;
Kb=exp(InterceptSlope(1))
n=InterceptSlope(2)
% Generate the points of the line with intercept
Newy = X*InterceptSlope;
% Plot data
figure(2)
scatter(x,y,'b')
hold on
plot(x,Newy,'r--')
xlabel('$\log(x), x= \mathrm{O}_2$ tension','interpreter','latex')
ylabel('$\log\left(\frac{f_b}{1-f_b}\right)$','interpreter','latex')
legend('exp. data','linear approx. with intercept')
