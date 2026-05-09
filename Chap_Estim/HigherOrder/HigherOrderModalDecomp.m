% Sequential modal approximation from a higher-order step response
clear; clc;

Ts = 0.05;
t  = (0:400)'*Ts;
y  = 2 - 1.2*exp(-0.5*t) - 0.5*exp(-2*t) - 0.2*exp(-8*t);
y  = y + 0.01*randn(size(y));

% Estimate steady state from the last samples
yss = mean(y(end-20:end));
r0  = y - yss;

% Slow mode from late samples
I1 = 220:length(t);
p1 = polyfit(t(I1),log(abs(r0(I1))),1);
lambda1 = -p1(1);
c1 = sign(mean(r0(I1)))*exp(p1(2));
r1 = r0 - c1*exp(-lambda1*t);

% Second mode from intermediate samples
I2 = 80:180;
p2 = polyfit(t(I2),log(abs(r1(I2))),1);
lambda2 = -p2(1);
c2 = sign(mean(r1(I2)))*exp(p2(2));
r2 = r1 - c2*exp(-lambda2*t);

% Fast mode from early samples
I3 = 5:60;
p3 = polyfit(t(I3),log(abs(r2(I3))),1);
lambda3 = -p3(1);
c3 = sign(mean(r2(I3)))*exp(p3(2));

yhat = yss + c1*exp(-lambda1*t) + c2*exp(-lambda2*t) + c3*exp(-lambda3*t);
plot(t,y,'r.',t,yhat,'b','LineWidth',1.2); grid on;
legend('Measured data','Sequential approximation','interpreter','latex');
xlabel('Time [s]','interpreter','latex'); ylabel('Output','interpreter','latex');

set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureHigherOrderIdent
