%% Multi-Asteroid Polarimetric Analysis
% This script fits the trigonometric model to 3 asteroids and 
% generates 2 summary figures (Regression and Diagnostics).

clear; clc; close all;

% Database loading
data = readmatrix('apd.csv'); 

% Configuration: [ID, Name]
asteroids = {1, 'Ceres'; 4179, 'Toutatis'; 64, 'Angelina'};
numAst = size(asteroids, 1);

% Model Definition
% p = [theta1, theta2, theta3, theta4]
modelfun = @(p,x) p(1) * (sin(deg2rad(x)).^p(2)) .* ...
                 (cos(deg2rad(x/2)).^p(3)) .* sin(deg2rad(x - p(4)));
beta0 = [0.1, 1.0, 1.0, 20.0]; % Initial guess

% Initialize Figures
hFit = figure('Name', 'Regression Results', 'Color', 'w');
hDiag = figure('Name', 'Model Diagnostics', 'Color', 'w');

for i = 1:numAst
    targetId = asteroids{i,1};
    targetName = asteroids{i,2};
    
    % 1. Data Filtering
    idx = data(:,1) == targetId & data(:,11) ~= -999.99;
    x_data = data(idx, 6); 
    y_data = data(idx, 11) / 100; % Convert % to ratio
    
    if isempty(x_data)
        warning('No data found for %s', targetName);
        continue;
    end
    
    % 2. Non-linear Regression
    opts = statset('nlinfit');
    beta = nlinfit(x_data, y_data, modelfun, beta0, opts);
    
    % 3. Performance Metrics
    y_pred = modelfun(beta, x_data);
    residuals = y_data - y_pred;
    rmse = sqrt(mean(residuals.^2)) * 100; % in %
    ss_res = sum(residuals.^2);
    ss_tot = sum((y_data - mean(y_data)).^2);
    r2 = 1 - (ss_res / ss_tot);
    
    % --- FIGURE 1: REGRESSION PLOTS ---
    figure(hFit);
    subplot(3, 1, i);
    x_fit = linspace(0, max(x_data)+5, 200);
    y_fit = modelfun(beta, x_fit);
    
    scatter(x_data, y_data * 100, 20, 'k', 'filled', 'MarkerFaceAlpha', 0.4); hold on;
    plot(x_fit, y_fit * 100, 'r', 'LineWidth', 2);
    yline(0, '--k');
    title(sprintf('(%d) %s | R^2: %.3f | RMSE: %.3f%%', targetId, targetName, r2, rmse));
    ylabel('P_r (%)');
    if i == 3; xlabel('Phase Angle (deg)'); end
    grid on;
    
    % --- FIGURE 2: DIAGNOSTIC PLOTS ---
    figure(hDiag);
    % Residuals vs Predicted
    subplot(3, 2, 2*i - 1);
    scatter(y_pred * 100, residuals * 100, 'filled');
    line([min(y_pred*100) max(y_pred*100)], [0 0], 'Color', 'r', 'LineStyle', '--');
    title(sprintf('%s: Residuals vs. Fitted', targetName));
    ylabel('Resid (%)');
    if i == 3; xlabel('Predicted P_r (%)'); end
    grid on;
    
    % Histogram
    subplot(3, 2, 2*i);
    histogram(residuals * 100, 12);
    title(sprintf('%s: Error Distribution', targetName));
    if i == 3; xlabel('Residual Value (%)'); end
    grid on;
end

%% Export to PDF
% Exporting Figure 1 (Regressions)
figure(hFit);
set(hFit, 'Units', 'centimeters', 'Position', [1, 1, 20, 25]);
print(hFit, 'Figure_Regressions', '-dpdf', '-painters');

% Exporting Figure 2 (Diagnostics)
figure(hDiag);
set(hDiag, 'Units', 'centimeters', 'Position', [1, 1, 20, 25]);
print(hDiag, 'Figure_Diagnostics', '-dpdf', '-painters');

fprintf('Processing complete. Figures saved as PDF.\n');