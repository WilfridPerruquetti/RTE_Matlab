% Complete linear regression example
clear; clc; close all;

% Data
x1 = [0; 1; 2; 3; 4; 5];
x2 = [1; 0; 2; 1; 3; 2];
y  = [3.1; 4.9; 8.8; 10.2; 14.1; 15.9];

% Design matrix
X = [ones(size(x1)), x1, x2];
[n,p] = size(X);

% Least-squares estimate
theta_hat = (X' * X) \ (X' * y);
y_hat = X * theta_hat;
e = y - y_hat;

% Performance indicators
SSE = e' * e;
MSE = SSE / n;
s2  = SSE / (n - p);
RMSE = sqrt(MSE);
y_bar = mean(y);
SST = sum((y - y_bar).^2);
R2 = 1 - SSE / SST;

% Covariance and t-statistics
Cov_theta = s2 * inv(X' * X);
se_theta = sqrt(diag(Cov_theta));
t_stat = theta_hat ./ se_theta;

% Hat matrix and leverages
H = X * inv(X' * X) * X';
h = diag(H);

% Loop for standardized residuals
r = zeros(n,1);
for i = 1:n
    r(i) = e(i) / sqrt(s2 * (1 - h(i)));
end

% Loop for Cook's distances
D = zeros(n,1);
for i = 1:n
    D(i) = (e(i)^2 / (p * s2)) * (h(i) / (1 - h(i))^2);
end

% Prediction for a new point
x_new = [1 6 2];
y_new_hat = x_new * theta_hat;

% Tables
summary_table = table((1:n)', x1, x2, y, y_hat, e, h, r, D, ...
    'VariableNames', {'Obs','x1','x2','y','y_hat','Residual', ...
    'Leverage','StdResidual','CooksDistance'});

fprintf('theta_hat =\n'); disp(theta_hat);
fprintf('SSE  = %.6f\n', SSE);
fprintf('MSE  = %.6f\n', MSE);
fprintf('RMSE = %.6f\n', RMSE);
fprintf('s^2  = %.6f\n', s2);
fprintf('R^2  = %.6f\n', R2);
fprintf('Prediction at x_new = [1 6 2]: %.6f\n', y_new_hat);
disp('Standard errors:'); disp(se_theta);
disp('t-statistics:'); disp(t_stat);
disp(summary_table);

% Conclusions from the tables
[~, idx_max_res] = max(abs(r));
[~, idx_max_cook] = max(D);
fprintf('Largest absolute standardized residual: observation %d (%.6f)\n', ...
    idx_max_res, r(idx_max_res));
fprintf('Largest Cook distance: observation %d (%.6f)\n', ...
    idx_max_cook, D(idx_max_cook));
if max(abs(r)) < 2
    fprintf('Conclusion on residuals: no observation exceeds the usual |r_i| > 2 threshold.\n');
else
    fprintf('Conclusion on residuals: at least one observation deserves attention.\n');
end
if max(D) < 1
    fprintf('Conclusion on Cook distances: no observation appears strongly influential under the D_i > 1 rule.\n');
else
    fprintf('Conclusion on Cook distances: at least one observation appears influential.\n');
end

% Diagnostic plots
figure('Name','Regression diagnostics','Color','w');
subplot(2,2,1);
plot(y_hat, e, 'o', 'LineWidth', 1.5, 'MarkerSize', 7); grid on;
xlabel('Fitted values'); ylabel('Residuals');
title('Residuals vs fitted');
yline(0,'--k');

subplot(2,2,2);
stem(1:n, D, 'filled'); grid on;
xlabel('Observation'); ylabel('Cook''s distance');
title('Cook''s distances');
yline(1,'--r','D = 1');

subplot(2,2,3);
stem(1:n, r, 'filled'); grid on;
xlabel('Observation'); ylabel('Standardized residual');
title('Standardized residuals');
yline(2,'--r'); yline(-2,'--r');

subplot(2,2,4);
qqplot(e); grid on;
title('Normal Q-Q plot of residuals');

saveas(gcf,'Figures/FigureCompleteAnalysis.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureCompleteAnalysis

cleanfigure;
matlab2tikz('Figures/FigureCompleteAnalysis.tex','width','\figwidth','height','\figheight','showInfo',false);
