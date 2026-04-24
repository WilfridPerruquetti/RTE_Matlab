%% fit_ppc_apd.m
% Nonlinear regression of the Penttila-Lumme-Muinonen trigonometric model
% for asteroid polarization phase curves.
%
% Before running: download APD data (apd.csv) from the APD archive and
% place it in the current MATLAB folder.

clear; clc; close all;

%% User choices
filename    = 'apd.csv';
targetId    = 1;          % 1 = Ceres, 2 = Pallas
targetName  = 'Ceres';
useFilter   = 'V';        % set to '' to use all filters

%% Read APD table
T = readtable(filename, 'TextType', 'string');
vars = string(T.Properties.VariableNames);

% Helper to locate columns despite possible naming differences
findVar = @(patterns) find_first_matching_variable(vars, patterns);

idVar     = findVar(["number","num","object","asteroid_number","mpc"]);
nameVar   = findVar(["name","asteroid_name","designation"]);
phaseVar  = findVar(["phase","phase_angle","alpha"]);
polVar    = findVar(["polarization","polarisation","pr","p_r","pol"]);
sigmaVar  = findVar(["sigma","error","err","unc","pr_err","pol_err"]);
filterVar = findVar(["filter","band"]);

if strlength(phaseVar) == 0 || strlength(polVar) == 0
    error('Could not identify the phase-angle and polarization columns.');
end

%% Select target asteroid
keep = true(height(T),1);

if strlength(idVar) > 0
    idData = numeric_column(T.(idVar));
    keep = keep & (idData == targetId);
elseif strlength(nameVar) > 0
    keep = keep & contains(lower(string(T.(nameVar))), lower(targetName));
else
    error('Could not identify asteroid ID or name column.');
end

if strlength(filterVar) > 0 && strlength(useFilter) > 0
    keep = keep & strcmpi(strtrim(string(T.(filterVar))), useFilter);
end

phaseDeg = numeric_column(T.(phaseVar));
polData  = numeric_column(T.(polVar));

good = keep & isfinite(phaseDeg) & isfinite(polData);
phaseDeg = phaseDeg(good);
polData  = polData(good);

% If APD values are stored in percent, convert them to fractions.
if max(abs(polData)) > 1.5
    polData = polData / 100;
end

if strlength(sigmaVar) > 0
    sigmaData = numeric_column(T.(sigmaVar));
    sigmaData = sigmaData(good);
    if max(abs(sigmaData)) > 1.5
        sigmaData = sigmaData / 100;
    end
    sigmaData(~isfinite(sigmaData) | sigmaData <= 0) = median(sigmaData(sigmaData>0));
else
    sigmaData = ones(size(polData));
end

% Sort by phase angle
[phaseDeg, order] = sort(phaseDeg);
polData = polData(order);
sigmaData = sigmaData(order);

fprintf('Target: (%d) %s\n', targetId, targetName);
fprintf('Number of data points: %d\n', numel(phaseDeg));

%% Trigonometric PPC model
model = @(theta, xdeg) theta(1) .* sin(deg2rad(xdeg)).^theta(2) .* ...
    cos(0.5*deg2rad(xdeg)).^theta(3) .* ...
    sin(deg2rad(xdeg) - theta(4));

% Weighted residuals
resfun = @(theta) (polData - model(theta, phaseDeg)) ./ sigmaData;

%% Initial guess and bounds
theta0 = [0.10, 1.0, 1.0, deg2rad(20)];
lb     = [0.0, 0.01, 0.01, 0.0];
ub     = [1.0, 8.0,  8.0,  pi];

opts = optimoptions('lsqnonlin', ...
    'Display', 'iter', ...
    'MaxFunctionEvaluations', 5000, ...
    'MaxIterations', 1000, ...
    'FunctionTolerance', 1e-12, ...
    'StepTolerance', 1e-12);

[thetaHat, resnorm, residuals, exitflag, output, lambda, jacobian] = ...
    lsqnonlin(resfun, theta0, lb, ub, opts);

%% Derived quantities
yHat = model(thetaHat, phaseDeg);
n = numel(polData);
p = numel(thetaHat);
SSE = sum((polData - yHat).^2);
MSE = SSE / n;
RMSE = sqrt(MSE);
R2 = 1 - SSE / sum((polData - mean(polData)).^2);

% Approximate covariance from Jacobian
if rank(jacobian) == p
    sigma2hat = sum(residuals.^2) / max(n-p,1);
    covTheta = sigma2hat * inv(jacobian.' * jacobian);
    seTheta = sqrt(diag(covTheta));
else
    covTheta = NaN(p);
    seTheta = NaN(p,1);
end

% Estimate inversion angle numerically as the first root after 5 degrees
xGrid = linspace(0.1, 40, 2000);
yGrid = model(thetaHat, xGrid);
sgn = sign(yGrid);
k = find(sgn(1:end-1).*sgn(2:end) <= 0 & xGrid(1:end-1) > 5, 1, 'first');
if ~isempty(k)
    xInv = interp1(yGrid(k:k+1), xGrid(k:k+1), 0, 'linear');
else
    xInv = NaN;
end

% Estimate minimum polarization and corresponding phase angle
[pmin, idxMin] = min(yGrid);
alphaMin = xGrid(idxMin);

%% Display results
fprintf('\nEstimated parameters:\n');
fprintf('theta1 = %.6f   (SE %.6f)\n', thetaHat(1), seTheta(1));
fprintf('theta2 = %.6f   (SE %.6f)\n', thetaHat(2), seTheta(2));
fprintf('theta3 = %.6f   (SE %.6f)\n', thetaHat(3), seTheta(3));
fprintf('theta4 = %.6f rad = %.3f deg   (SE %.6f rad)\n', ...
    thetaHat(4), rad2deg(thetaHat(4)), seTheta(4));

fprintf('\nGoodness of fit:\n');
fprintf('SSE  = %.6e\n', SSE);
fprintf('RMSE = %.6e\n', RMSE);
fprintf('R^2  = %.6f\n', R2);
fprintf('Estimated inversion angle alpha_inv = %.3f deg\n', xInv);
fprintf('Estimated minimum polarization Pmin = %.4f at alpha = %.3f deg\n', ...
    pmin, alphaMin);

%% Plot
figure('Color','w');
errorbar(phaseDeg, polData, sigmaData, 'ko', 'MarkerFaceColor','k', ...
    'DisplayName', 'APD data');
hold on;
plot(xGrid, yGrid, 'r-', 'LineWidth', 2, 'DisplayName', 'Trigonometric fit');
yline(0,'--','Color',[0.4 0.4 0.4]);
xlabel('Phase angle (deg)');
ylabel('Degree of polarization');
title(sprintf('Asteroid (%d) %s: trigonometric PPC fit', targetId, targetName));
legend('Location','best');
grid on; box on;

%% ---------- Local helper functions ----------
function name = find_first_matching_variable(vars, patterns)
    name = ""; % empty string means not found
    lowerVars = lower(vars);
    for pattern = patterns
        idx = find(contains(lowerVars, lower(pattern)), 1, 'first');
        if ~isempty(idx)
            name = vars(idx);
            return;
        end
    end
end

function x = numeric_column(col)
    if isnumeric(col)
        x = double(col);
    elseif islogical(col)
        x = double(col);
    else
        x = str2double(string(col));
    end
end