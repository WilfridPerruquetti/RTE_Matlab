%% austin_housing_model_comparison.m
% Compare three models for Austin housing:
%   1) linear model on original scale
%   2) direct nonlinear exponential model on original scale
%   3) log-linear model obtained from log(y) = log(a) + b*t
%
% Run this script from the folder regression/matlab.

clear; clc; close all;

outDir   = 'generated_figures';
cacheDir = 'rdatasets_cache';
if ~exist(outDir, 'dir'), mkdir(outDir); end
if ~exist(cacheDir, 'dir'), mkdir(cacheDir); end

base = 'https://vincentarelbundock.github.io/Rdatasets/csv';
url  = [base '/ggplot2/txhousing.csv'];
localFile = fullfile(cacheDir, 'txhousing.csv');

%% Load dataset
Ttx = load_rdataset(url, localFile);

%% Build the Austin yearly dataset
mask = strcmp(string(Ttx.city), 'Austin') & isfinite(Ttx.year) & isfinite(Ttx.median);
Taustin = groupsummary(Ttx(mask,:), 'year', 'mean', 'median');
Taustin.t = Taustin.year - min(Taustin.year);

t = double(Taustin.t);
y = double(Taustin.mean_median);

% Positive response required for log-transform
good = isfinite(t) & isfinite(y) & (y > 0);
t = t(good);
y = y(good);

n = numel(y);

fprintf('\nAustin housing model comparison\n');
fprintf('Number of yearly observations: %d\n', n);

%% ============================================================
%% Model 1: Linear model y = alpha + beta*t + epsilon
%% ============================================================
Xlin = [ones(n,1), t];
thetaLin = Xlin \ y;
alphaHat = thetaLin(1);
betaHat  = thetaLin(2);

yhatLin = Xlin * thetaLin;
resLin  = y - yhatLin;

SSElin = sum(resLin.^2);
MSElin = SSElin / n;
SST    = sum((y - mean(y)).^2);
R2lin  = 1 - SSElin / SST;

pLin = 2;
if n > pLin
    s2Lin = SSElin / (n - pLin);
else
    s2Lin = NaN;
end

Hlin = Xlin / (Xlin' * Xlin) * Xlin';
hLin = diag(Hlin);

if isfinite(s2Lin) && s2Lin > 0
    stdResLin = resLin ./ (sqrt(s2Lin) * sqrt(max(1 - hLin, 1e-12)));
    cookLin = (resLin.^2 / (pLin * s2Lin)) .* hLin ./ max((1 - hLin).^2, 1e-12);
else
    stdResLin = NaN(size(resLin));
    cookLin = NaN(size(resLin));
end

%% ============================================================
%% Model 2: Direct nonlinear exponential model
%% y = a*exp(b*t) + epsilon
%% ============================================================
expModel = @(theta, x) theta(1) .* exp(theta(2) .* x);

theta0 = [1e5; 0.03];
lb = [0; 0];
ub = [1e7; 1];

opts = optimoptions('lsqcurvefit', ...
    'Display', 'iter', ...
    'MaxIterations', 1000, ...
    'MaxFunctionEvaluations', 50000, ...
    'FunctionTolerance', 1e-12, ...
    'StepTolerance', 1e-12);

[thetaExp, ~, resExp, exitflagExp, outputExp, ~, Jexp] = ...
    lsqcurvefit(expModel, theta0, t, y, lb, ub, opts);

aHat = thetaExp(1);
bHat = thetaExp(2);

yhatExp = expModel(thetaExp, t);

SSEexp = sum((y - yhatExp).^2);
MSEexp = SSEexp / n;
R2exp  = 1 - SSEexp / SST;

pExp = 2;
if n > pExp
    s2Exp = SSEexp / (n - pExp);
else
    s2Exp = NaN;
end

Jexp = full(Jexp);
Hexp = Jexp * pinv(Jexp' * Jexp) * Jexp';
hExp = diag(Hexp);

if isfinite(s2Exp) && s2Exp > 0
    stdResExp = resExp ./ (sqrt(s2Exp) * sqrt(max(1 - hExp, 1e-12)));
    cookExp = (resExp.^2 / (pExp * s2Exp)) .* hExp ./ max((1 - hExp).^2, 1e-12);
else
    stdResExp = NaN(size(resExp));
    cookExp = NaN(size(resExp));
end

%% ============================================================
%% Model 3: Log-linear model
%% log(y) = c + b*t + eta, with a = exp(c)
%% ============================================================
z = log(y);
Xlog = [ones(n,1), t];
thetaLog = Xlog \ z;

cHat   = thetaLog(1);
bLogHat = thetaLog(2);
aLogHat = exp(cHat);

zhat = Xlog * thetaLog;
resLog = z - zhat;

% Exponential curve back on original scale
yhatLogOriginal = aLogHat * exp(bLogHat * t);

% On log scale
SSElog = sum(resLog.^2);
MSElog = SSElog / n;
SSTlog = sum((z - mean(z)).^2);
R2log  = 1 - SSElog / SSTlog;

% On original scale, to compare with Models 1 and 2
SSElogOriginal = sum((y - yhatLogOriginal).^2);
MSElogOriginal = SSElogOriginal / n;
R2logOriginal  = 1 - SSElogOriginal / SST;

pLog = 2;
if n > pLog
    s2Log = SSElog / (n - pLog);
else
    s2Log = NaN;
end

Hlog = Xlog / (Xlog' * Xlog) * Xlog';
hLog = diag(Hlog);

if isfinite(s2Log) && s2Log > 0
    stdResLog = resLog ./ (sqrt(s2Log) * sqrt(max(1 - hLog, 1e-12)));
    cookLog = (resLog.^2 / (pLog * s2Log)) .* hLog ./ max((1 - hLog).^2, 1e-12);
else
    stdResLog = NaN(size(resLog));
    cookLog = NaN(size(resLog));
end

%% ============================================================
%% Print results
%% ============================================================
fprintf('\n====================================================\n');
fprintf('MODEL 1: LINEAR MODEL y = alpha + beta*t + epsilon\n');
fprintf('====================================================\n');
fprintf('alpha = %.6f\n', alphaHat);
fprintf('beta  = %.6f\n', betaHat);
fprintf('SSE   = %.6e\n', SSElin);
fprintf('MSE   = %.6e\n', MSElin);
fprintf('s^2   = %.6e\n', s2Lin);
fprintf('R^2   = %.6f\n', R2lin);
fprintf('max |r_i| = %.6f\n', max(abs(stdResLin)));
fprintf('max D_i   = %.6f\n', max(cookLin));

fprintf('\n====================================================\n');
fprintf('MODEL 2: DIRECT NONLINEAR EXPONENTIAL y = a*exp(b*t)\n');
fprintf('====================================================\n');
fprintf('a    = %.6f\n', aHat);
fprintf('b    = %.6f\n', bHat);
fprintf('SSE  = %.6e\n', SSEexp);
fprintf('MSE  = %.6e\n', MSEexp);
fprintf('s^2  = %.6e\n', s2Exp);
fprintf('R^2  = %.6f\n', R2exp);
fprintf('max |r_i| = %.6f\n', max(abs(stdResExp)));
fprintf('max D_i   = %.6f\n', max(cookExp));
fprintf('exitflag  = %d\n', exitflagExp);
disp(outputExp);

fprintf('\n====================================================\n');
fprintf('MODEL 3: LOG-LINEAR MODEL log(y) = c + b*t + eta\n');
fprintf('====================================================\n');
fprintf('c       = %.6f\n', cHat);
fprintf('b       = %.6f\n', bLogHat);
fprintf('a=exp(c)= %.6f\n', aLogHat);
fprintf('SSE_log = %.6e\n', SSElog);
fprintf('MSE_log = %.6e\n', MSElog);
fprintf('s^2_log = %.6e\n', s2Log);
fprintf('R^2_log = %.6f\n', R2log);
fprintf('SSE on original scale = %.6e\n', SSElogOriginal);
fprintf('MSE on original scale = %.6e\n', MSElogOriginal);
fprintf('R^2 on original scale = %.6f\n', R2logOriginal);
fprintf('max |r_i| on log scale = %.6f\n', max(abs(stdResLog)));
fprintf('max D_i on log scale   = %.6f\n', max(cookLog));

%% ============================================================
%% Save summary table
%% ============================================================
summaryTable = table( ...
    ["Linear"; "Direct nonlinear exponential"; "Log-linear exponential"], ...
    [alphaHat; aHat; aLogHat], ...
    [betaHat;  bHat; bLogHat], ...
    [SSElin; SSEexp; SSElogOriginal], ...
    [MSElin; MSEexp; MSElogOriginal], ...
    [s2Lin;  s2Exp;  s2Log], ...
    [R2lin;  R2exp;  R2logOriginal], ...
    [max(abs(stdResLin)); max(abs(stdResExp)); max(abs(stdResLog))], ...
    [max(cookLin); max(cookExp); max(cookLog)], ...
    'VariableNames', {'model','param1','param2','SSE','MSE','s2','R2','maxAbsStdResidual','maxCook'} ...
    );

writetable(summaryTable, fullfile(outDir, 'matlab_austin_housing_model_comparison_summary.csv'));

%% ============================================================
%% Figure 1: Fitted curves on original scale
%% ============================================================
figure('Color', 'w', 'Position', [100, 100, 950, 700]);
scatter(t, y, 45, 'filled', 'DisplayName', 'Austin yearly data');
hold on;

tt = linspace(min(t), max(t), 400)';
yLinCurve = alphaHat + betaHat * tt;
yExpCurve = aHat * exp(bHat * tt);
yLogCurve = aLogHat * exp(bLogHat * tt);

plot(tt, yLinCurve, 'b-', 'LineWidth', 2, 'DisplayName', 'Linear fit');
plot(tt, yExpCurve, 'r-', 'LineWidth', 2, 'DisplayName', 'Direct nonlinear exponential fit');
plot(tt, yLogCurve, 'g--', 'LineWidth', 2, 'DisplayName', 'Log-linear exponential fit');

grid on; box on;
xlabel('Years since first Austin observation');
ylabel('Mean median house price');
title('Austin housing: model comparison on original scale');
legend('Location', 'best');

% Exporting Figure 1 (Fitted curves model comparison)
print(gcf,fullfile(outDir, 'matlab_austin_housing_model_comparison_fit'), '-dpdf', '-bestfit','-painters');
exportgraphics(gcf, fullfile(outDir, 'matlab_austin_housing_model_comparison_fit.png'), 'Resolution', 180);

%% ============================================================
%% Figure 2: Residual plots
%% ============================================================
figure('Color', 'w', 'Position', [100, 100, 1200, 900]);

subplot(3,2,1);
scatter(yhatLin, resLin, 30, 'filled');
yline(0, '--k');
grid on;
title('Linear: residuals vs fitted');
xlabel('fitted');
ylabel('residuals');

subplot(3,2,2);
stem(cookLin, 'filled');
hold on;
yline(4/n, ':r');
grid on;
title('Linear: Cook distance');
xlabel('index');
ylabel('D_i');

subplot(3,2,3);
scatter(yhatExp, resExp, 30, 'filled');
yline(0, '--k');
grid on;
title('Direct nonlinear exponential: residuals vs fitted');
xlabel('fitted');
ylabel('residuals');

subplot(3,2,4);
stem(cookExp, 'filled');
hold on;
yline(4/n, ':r');
grid on;
title('Direct nonlinear exponential: Cook distance');
xlabel('index');
ylabel('D_i');

subplot(3,2,5);
scatter(zhat, resLog, 30, 'filled');
yline(0, '--k');
grid on;
title('Log-linear: residuals vs fitted (log scale)');
xlabel('fitted log(y)');
ylabel('residuals');

subplot(3,2,6);
stem(cookLog, 'filled');
hold on;
yline(4/n, ':r');
grid on;
title('Log-linear: Cook distance');
xlabel('index');
ylabel('D_i');

% Exporting Figure 2 (Residual plots)
print(gcf,fullfile(outDir, 'matlab_austin_housing_model_comparison_diagnostics'), '-dpdf', '-bestfit','-painters');
exportgraphics(gcf, fullfile(outDir, 'matlab_austin_housing_model_comparison_diagnostics.png'), 'Resolution', 180);

%% ============================================================
%% Figure 3: Standardized residuals
%% ============================================================
figure('Color', 'w', 'Position', [100, 100, 1000, 900]);

subplot(3,1,1);
stem(stdResLin, 'filled');
hold on;
yline(3, ':r'); yline(-3, ':r'); yline(0, '--k');
grid on;
title('Linear model: standardized residuals');
xlabel('index');
ylabel('r_i');

subplot(3,1,2);
stem(stdResExp, 'filled');
hold on;
yline(3, ':r'); yline(-3, ':r'); yline(0, '--k');
grid on;
title('Direct nonlinear exponential model: standardized residuals');
xlabel('index');
ylabel('r_i');

subplot(3,1,3);
stem(stdResLog, 'filled');
hold on;
yline(3, ':r'); yline(-3, ':r'); yline(0, '--k');
grid on;
title('Log-linear model: standardized residuals (log scale)');
xlabel('index');
ylabel('r_i');

% Exporting Figure 2 (Standardized residuals)
print(gcf,fullfile(outDir, 'matlab_austin_housing_model_comparison_stdres'), '-dpdf', '-bestfit','-painters');
exportgraphics(gcf, fullfile(outDir, 'matlab_austin_housing_model_comparison_stdres.png'), 'Resolution', 180);

%% ============================================================
%% Local helper
%% ============================================================
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