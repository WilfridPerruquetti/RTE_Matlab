clc;
clear;
close all;
% U.S. census data (population in millions)
t = [1790;1800;1810;1820;1830;1840;1850;1860;1870;1880;1890;1900;1910;1920;1930;1940;1950;1960;1970;1980;1990];
pop = [3.929;5.308;7.240;9.638;12.866;17.069;23.192;31.443; ...
 38.558;50.156;62.948;75.996;91.972;105.711;122.775;131.669; ...
 150.697;179.323;203.185;226.546;248.710];
x0 = pop(1);
%% 1) Early exponential growth
% Same spirit as your script
tbegin = t(2:6);
popbegin = pop(2:6);
a_exp = (tbegin-1790)\log(popbegin/x0);
ybegin = x0.*exp(a_exp.*(tbegin-1790));
residual_exp = sum((ybegin-popbegin).^2);

e = (ybegin-popbegin);
z = popbegin;
[n,p] = size(z);

% Performance indicators
SSE = sum(e.^2);
MSE = SSE / n;
s2 = SSE / (n - p);
RMSE = sqrt(s2);
SST = sum((z - mean(z)).^2);
R2 = 1 - SSE / SST;
adjR2 = 1 - (SSE/(n-p)) / (SST/(n-1));


fprintf('Exponential fit on early data\n');
fprintf('a_exp = %.8f\n', a_exp);
fprintf('Residual_exp = %.6f\n\n', residual_exp);

fprintf('SSE_exp = %.6f\n\n', SSE);
fprintf('MSE_exp = %.6f\n\n', MSE);
fprintf('RMSE_exp = %.6f\n\n', RMSE);
fprintf('SST_exp = %.6f\n\n', SST);
fprintf('R2_exp = %.6f\n\n', R2);
fprintf('adjR2_exp = %.6f\n\n', adjR2);

%% 2) Logistic model
% x(t) = x0xmax / (x0 + exp(-axmax*(t-1790))(xmax-x0))
modelfun = @(param,time) ...
(x0.*param(1)) ./ (x0 + exp(-param(2).*(time-1790)) .* (param(1)-x0));
%% 3) Logistic fit up to 1940
% If you want exactly 15 points, use 1:15.
% To include 1940, use 1:16.
idx_1940 = 1:16;
t_1940 = t(idx_1940);
pop_1940 = pop(idx_1940);
InitialGuess = [50; 0.02];
[param_1940, r_1940, J_1940, covb_1940, mse_1940] = nlinfit(t_1940, pop_1940, modelfun, InitialGuess);
xmax_1940 = param_1940(1);
a_1940 = param_1940(2);
pop_1940_fit = modelfun(param_1940, t_1940);
residual_1940 = sum((pop_1940_fit - pop_1940).^2);

e = (pop_1940_fit - pop_1940);
z = pop_1940;
[n,p] = size(z);

% Performance indicators
SSE = sum(e.^2);
MSE = SSE / n;
s2 = SSE / (n - p);
RMSE = sqrt(s2);
SST = sum((z - mean(z)).^2);
R2 = 1 - SSE / SST;
adjR2 = 1 - (SSE/(n-p)) / (SST/(n-1));

fprintf('Logistic fit on 1790--1940 data\n');
fprintf('xmax = %.4f\n', xmax_1940);
fprintf('a = %.8f\n', a_1940);
fprintf('Residual = %.6f\n', residual_1940);
fprintf('MSE = %.6f\n\n', mse_1940);
fprintf('SSE = %.6f\n\n', SSE);
fprintf('MSE = %.6f\n\n', MSE);
fprintf('RMSE = %.6f\n\n', RMSE);
fprintf('SST = %.6f\n\n', SST);
fprintf('R2 = %.6f\n\n', R2);
fprintf('adjR2 = %.6f\n\n', adjR2);
 
 %% 4) Prediction quality after 1940 using the early logistic fit
 idx_after_1940 = 17:length(t);
 t_after_1940 = t(idx_after_1940);
 pop_after_1940 = pop(idx_after_1940);
pop_pred_after_1940 = modelfun(param_1940, t_after_1940);
 rmse_after_1940 = sqrt(mean((pop_pred_after_1940 - pop_after_1940).^2));
 relerr_after_1940 = norm(pop_pred_after_1940 - pop_after_1940) / norm(pop_after_1940);
fprintf('Prediction quality after 1940 using logistic fit estimated on 1790--1940\n');
 fprintf('RMSE = %.6f\n', rmse_after_1940);
 fprintf('Relative error = %.6f\n\n', relerr_after_1940);
%% 5) Logistic fit on all data
 [param_all, r_all, J_all, covb_all, mse_all] = nlinfit(t, pop, modelfun, InitialGuess);
xmax_all = param_all(1);
 a_all = param_all(2);
 pop_all_fit = modelfun(param_all, t);
 residual_all = sum((pop_all_fit - pop).^2);
fprintf('Logistic fit on 1790--1990 data\n');
 fprintf('xmax = %.4f\n', xmax_all);
 fprintf('a = %.8f\n', a_all);
 fprintf('Residual = %.6f\n', residual_all);
 fprintf('MSE = %.6f\n\n', mse_all);
%% 6) Residual analysis
 residuals_1940 = pop_1940 - pop_1940_fit;
 residuals_all = pop - pop_all_fit;
fprintf('Residual summary (1790--1940 fit)\n');
 fprintf('max abs residual = %.6f\n', max(abs(residuals_1940)));
 fprintf('mean residual = %.6f\n\n', mean(residuals_1940));
fprintf('Residual summary (1790--1990 fit)\n');
 fprintf('max abs residual = %.6f\n', max(abs(residuals_all)));
 fprintf('mean residual = %.6f\n\n', mean(residuals_all));
%% 7) Confidence intervals (approximate, from nlparci)
 ci_1940 = nlparci(param_1940, r_1940, 'jacobian', J_1940);
 ci_all = nlparci(param_all, r_all, 'jacobian', J_all);
fprintf('Approximate 95%% confidence intervals for fit on 1790--1940\n');
 fprintf('xmax in [%.4f, %.4f]\n', ci_1940(1,1), ci_1940(1,2));
 fprintf('a in [%.8f, %.8f]\n\n', ci_1940(2,1), ci_1940(2,2));
fprintf('Approximate 95%% confidence intervals for fit on 1790--1990\n');
 fprintf('xmax in [%.4f, %.4f]\n', ci_all(1,1), ci_all(1,2));
 fprintf('a in [%.8f, %.8f]\n\n', ci_all(2,1), ci_all(2,2));
%% 8) Dense time grid for plotting
newt = (1790:2000)';
pop_exp_dense = x0*exp(a_exp*(newt-1790));
pop_log_1940_dense = modelfun(param_1940, newt);
pop_log_all_dense = modelfun(param_all, newt);
%% 9) Figures
 figure(1);
 scatter(t, pop, 40, 'filled');
 grid on;
 xlabel('Year');
 ylabel('Population (millions)');
 title('U.S. census data');
saveas(gcf,'FigureData.pdf')
figure(2);
 scatter(tbegin, popbegin, 40, 'filled');
 hold on;
 plot(newt, pop_exp_dense, 'LineWidth', 1.5);
 grid on;
 xlabel('Year');
 ylabel('Population (millions)');
 title('Early exponential growth fit');
 legend('Data used for fit', 'Exponential fit', 'Location', 'northwest');
saveas(gcf,'FigureExpFit.pdf')
figure(3);
 scatter(t, pop, 40, 'filled');
 hold on;
 plot(newt, pop_log_1940_dense, 'b', 'LineWidth', 1.5);
 plot(newt, pop_log_all_dense, 'r--', 'LineWidth', 1.5);
 grid on;
 xlabel('Year');
 ylabel('Population (millions)');
 title('Comparison of logistic fits');
 legend('Data', 'Logistic fit on 1790--1940', 'Logistic fit on 1790--1990', 'Location', 'southeast');
saveas(gcf,'FigureLogisticFit.pdf')
figure(4);
 subplot(2,1,1);
 stem(t_1940, residuals_1940, 'filled');
 grid on;
 xlabel('Year');
 ylabel('Residual');
 title('Residuals of logistic fit on 1790--1940');
saveas(gcf,'FigureResiduals1940.pdf')
subplot(2,1,2);
 stem(t, residuals_all, 'filled');
 grid on;
 xlabel('Year');
 ylabel('Residual');
 title('Residuals of logistic fit on 1790--1990');
 saveas(gcf,'FigureResiduals1990.pdf')
figure(5);
 scatter(t, pop, 40, 'filled');
 hold on;
 plot(newt, pop_log_1940_dense, 'b', 'LineWidth', 1.5);
 scatter(t_after_1940, pop_pred_after_1940, 50, 'r', 'filled');
 grid on;
 xlabel('Year');
 ylabel('Population (millions)');
 title('Post-1940 prediction using the early logistic fit');
 legend('Observed data', 'Logistic fit estimated up to 1940', 'Predictions after 1940', 'Location', 'southeast');
 saveas(gcf,'FigurePrediction.pdf')