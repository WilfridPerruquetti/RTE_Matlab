% Overdamped second-order identification from a step response
clear; clc;

Ts = 0.01;
t  = (0:Ts:8)';
u0 = 1;

% Example data: replace y by measured data
ktrue = 1.5; tau1true = 0.20; tau2true = 1.30;
y = ktrue*u0*(1 - (tau1true*exp(-t/tau1true) - tau2true*exp(-t/tau2true)) ...
/(tau1true-tau2true));
y = y + 0.01*randn(size(y));

% 1) steady-state gain
N0 = round(0.8*length(y));
yss = mean(y(N0:end));
k0  = yss/u0;

% 2) crossing times at 25% and 75%
y25 = 0.25*yss;
y75 = 0.75*yss;
i25 = find(y >= y25,1,'first');
i75 = find(y >= y75,1,'first');
t25 = t(i25);
t75 = t(i75);

r = t25/t75;
P = -18.56075*r + 0.57311/(r-0.20747) + 4.16423;
Q = 14.2797*r^3 - 9.3891*r^2 + 0.25437*r + 1.32148;

tau20 = (t75-t25)/(Q*(1+1/P));
tau10 = tau20/P;

% 3) nonlinear refinement
model_od = @(p,t) p(1)*u0*(1 - (p(2)*exp(-t/p(2)) - p(3)*exp(-t/p(3))) ...
/(p(2)-p(3)));
cost_od = @(p) sum((y - model_od(p,t)).^2);

p0   = [k0 tau10 tau20];
phat = fminsearch(cost_od,p0);

khat  = phat(1);
tau1h = min(phat(2),phat(3));
tau2h = max(phat(2),phat(3));
yhat  = khat*u0*(1 - (tau1h*exp(-t/tau1h) - tau2h*exp(-t/tau2h)) ...
/(tau1h-tau2h));
R2 = 1 - sum((y-yhat).^2)/sum((y-mean(y)).^2);

fprintf('Initial guess: k=%.4f, tau1=%.4f, tau2=%.4f\n',k0,tau10,tau20);
fprintf('Refined fit  : k=%.4f, tau1=%.4f, tau2=%.4f\n',khat,tau1h,tau2h);
fprintf('R2 = %.5f\n',R2);

figure;
plot(t,y,'b',t,yhat,'r--','LineWidth',1.2);
grid on; xlabel('Time [s]','interpreter','latex'); ylabel('Output','interpreter','latex');
legend('Measured data','Estimated model','Location','best','interpreter','latex');
title('Overdamped second-order identification','interpreter','latex');
saveas(gcf,'FigureEx_SecondOrder_ZetaGrand.pdf')