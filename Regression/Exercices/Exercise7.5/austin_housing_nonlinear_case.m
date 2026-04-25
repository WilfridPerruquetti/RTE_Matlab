%% austin_housing_nonlinear_case.m
% Nonlinear regression focused only on Austin housing data from Rdatasets.
% Run this script from the folder regression/matlab.

clear; clc; close all;

outDir = 'generated_figures';
cacheDir = 'rdatasets_cache';
if ~exist(outDir, 'dir'), mkdir(outDir); end
if ~exist(cacheDir, 'dir'), mkdir(cacheDir); end

base = 'https://vincentarelbundock.github.io/Rdatasets/csv';
url = [base '/ggplot2/txhousing.csv'];
localFile = fullfile(cacheDir, 'txhousing.csv');

%% Load dataset
Ttx = load_rdataset(url, localFile);

%% Select Austin and aggregate by year
mask = strcmp(string(Ttx.city), 'Austin') & isfinite(Ttx.year) & isfinite(Ttx.median);
Taustin = groupsummary(Ttx(mask,:), 'year', 'mean', 'median');
Taustin.t = Taustin.year - min(Taustin.year);

x = double(Taustin.t);
y = double(Taustin.mean_median);

%% Nonlinear model: exponential growth
% y = a * exp(b*x)
model = @(theta, x) theta(1) * exp(theta(2) * x);
theta0 = [1e5; 0.03];
lb = [0; 0];
ub = [1e7; 1];

opts = optimoptions('lsqcurvefit', 'Display', 'iter', ...
    'MaxIterations', 1000, ...
    'MaxFunctionEvaluations', 50000, ...
    'FunctionTolerance', 1e-12, ...
    'StepTolerance', 1e-12);

[thetaHat, ~, residuals, exitflag, output, ~, J] = lsqcurvefit(model, theta0, x, y, lb, ub, opts);

yhat = model(thetaHat, x);
n = numel(y);
p = numel(thetaHat);

%% Goodness-of-fit quantities
SSE = sum((y - yhat).^2);
MSE = SSE / n;

if n > p
    s2 = SSE / (n - p);
else
    s2 = NaN;
end

SST = sum((y - mean(y)).^2);
if SST > 0
    R2 = 1 - SSE / SST;
else
    R2 = NaN;
end

%% Diagnostics
J = full(J);
JTJ = J' * J;
H = J * pinv(JTJ) * J';
h = diag(H);

if isfinite(s2) && s2 > 0
    s = sqrt(s2);
    stdResiduals = residuals ./ (s * sqrt(max(1 - h, 1e-12)));
    cook = (residuals.^2 / (p * s2)) .* h ./ max((1 - h).^2, 1e-12);
else
    stdResiduals = NaN(size(residuals));
    cook = NaN(size(residuals));
end

%% Print results
fprintf('\nAustin housing nonlinear regression\n');
fprintf('Model: y = a * exp(b*x)\n');
fprintf('Number of aggregated yearly observations: %d\n', n);
fprintf('a = %.6f\n', thetaHat(1));
fprintf('b = %.6f\n', thetaHat(2));
fprintf('SSE = %.6e\n', SSE);
fprintf('MSE = %.6e\n', MSE);
fprintf('s^2 = %.6e\n', s2);
fprintf('R^2 = %.6f\n', R2);
fprintf('Max |standardized residual| = %.6f\n', max(abs(stdResiduals)));
fprintf('Max Cook distance = %.6f\n', max(cook));
fprintf('Exit flag = %d\n', exitflag);
disp(output);

%% Save summary table
summaryTable = table( ...
    "Austin housing", "expgrowth", n, thetaHat(1), thetaHat(2), SSE, MSE, s2, SST, R2, ...
    max(abs(stdResiduals)), max(cook), ...
    'VariableNames', {'label','model','n','theta1','theta2','SSE','MSE','s2','SST','R2','maxAbsStdResidual','maxCook'});

writetable(summaryTable, fullfile(outDir, 'matlab_austin_housing_summary.csv'));

%% Main fit figure
figure('Color', 'w', 'Position', [100, 100, 900, 700]);
scatter(x, y, 40, 'filled', 'DisplayName', 'Yearly mean median price');
hold on;

xx = linspace(min(x), max(x), 300)';
yy = model(thetaHat, xx);

plot(xx, yy, 'r-', 'LineWidth', 2, 'DisplayName', 'Nonlinear fit');
grid on; box on;
xlabel('Years since first Austin observation');
ylabel('Mean median house price');
title('Austin housing: nonlinear regression');
legend('Location', 'best');

exportgraphics(gcf, fullfile(outDir, 'matlab_austin_housing_fit.png'), 'Resolution', 180);
% Exporting Figure 1 (Regressions)
print(gcf,fullfile(outDir, 'matlab_austin_housing_fit'), '-dpdf', '-bestfit','-painters');
%% Diagnostic figure
figure('Color', 'w', 'Position', [100, 100, 1100, 350]);

subplot(1,3,1);
scatter(yhat, residuals, 30, 'filled');
yline(0, '--k');
grid on;
title('Residuals vs fitted');
xlabel('fitted');
ylabel('residuals');

subplot(1,3,2);
stem(stdResiduals, 'filled');
hold on;
yline(3, ':r');
yline(-3, ':r');
yline(0, '--k');
grid on;
title('Standardized residuals');
xlabel('index');
ylabel('r_i');

subplot(1,3,3);
stem(cook, 'filled');
hold on;
yline(4/n, ':r');
grid on;
title('Cook distance');
xlabel('index');
ylabel('D_i');

% Exporting Figure 2 (Diagnostics)
print(gcf,fullfile(outDir, 'matlab_austin_housing_diagnostics'), '-dpdf', '-bestfit','-painters');
exportgraphics(gcf, fullfile(outDir, 'matlab_austin_housing_diagnostics.png'), 'Resolution', 180);

%% ---------- Local helper ----------
function T = load_rdataset(url, localFile)
    if ~exist(localFile, 'file')
        websave(localFile, url);
    end

    T = readtable(localFile, 'TextType', 'string');
    idx = find(strcmpi(T.Properties.VariableNames, 'rownames'), 1);
    if ~isempty(idx)
        T(:, idx) = [];
    end
end