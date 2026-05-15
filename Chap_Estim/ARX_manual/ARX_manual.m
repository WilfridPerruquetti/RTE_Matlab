% Higher-order identification: PRBS data + least squares (no toolbox required)
clear; clc;

N = 1500;
u = idinput(N,'prbs');     % requires System Identification Toolbox for idinput
u = u(:);                  % alternatively: u = sign(sin(2*pi*(0.1*(1:N)' ...
%   + 0.37*(1:N)'.^2/N)));

% Discrete-time system (3rd order example)
num = [0  0.08 0.05 0.02];
den = [1 -2.2 1.69 -0.44];

y = filter(num, den, u) + 0.02*randn(N,1);

% Build regression matrix for ARX(3,3,1)
na = 3; nb = 3; nk = 1;
n0 = max(na, nb+nk-1) + 1;
Phi = zeros(N-n0+1, na+nb);
Y   = y(n0:N);
for k = n0:N
Phi(k-n0+1,:) = [-y(k-1) -y(k-2) -y(k-3) u(k-1) u(k-2) u(k-3)];
end

theta = Phi \ Y;

ahat = [1 theta(1:na)'];
bhat = [0 theta(na+1:end)'];
yhat = filter(bhat, ahat, u);

R2 = 1 - sum((y(n0:end)-yhat(n0:end)).^2) / ...
sum((y(n0:end)-mean(y(n0:end))).^2);
fprintf('Estimated parameters: '); disp(theta.');
fprintf('R2 = %.5f\n', R2);

figure;
plot(y,'b'); hold on;
plot(yhat,'r--','LineWidth',1.1);
grid on; xlabel('Sample $k$','Interpreter','latex');
ylabel('$y_k$','Interpreter','latex');
legend('Measured','ARX model','Interpreter','latex','Location','best');
title('Higher-order identification from PRBS data','Interpreter','latex');

set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureARXmanual