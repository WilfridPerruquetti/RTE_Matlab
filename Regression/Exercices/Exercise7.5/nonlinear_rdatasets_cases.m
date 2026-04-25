%% nonlinear_rdatasets_cases.m
% Nonlinear regression on 11 cases drawn from the Rdatasets repository.
% Run this script from the folder regression/matlab.

clear; clc; close all;

outDir = '../generated_figures';
cacheDir = 'rdatasets_cache';
if ~exist(outDir, 'dir'), mkdir(outDir); end
if ~exist(cacheDir, 'dir'), mkdir(cacheDir); end

base = 'https://vincentarelbundock.github.io/Rdatasets/csv';
urls = struct( ...
    'faithful', [base '/datasets/faithful.csv'], ...
    'diamonds', [base '/ggplot2/diamonds.csv'], ...
    'msleep', [base '/ggplot2/msleep.csv'], ...
    'penguins', [base '/palmerpenguins/penguins.csv'], ...
    'mpg', [base '/ggplot2/mpg.csv'], ...
    'economics', [base '/ggplot2/economics.csv'], ...
    'txhousing', [base '/ggplot2/txhousing.csv']);

Tfaithful = load_rdataset(urls.faithful, fullfile(cacheDir, 'faithful.csv'));
Tdiamonds = load_rdataset(urls.diamonds, fullfile(cacheDir, 'diamonds.csv'));
Tmsleep   = load_rdataset(urls.msleep, fullfile(cacheDir, 'msleep.csv'));
Tpenguins = load_rdataset(urls.penguins, fullfile(cacheDir, 'penguins.csv'));
Tmpg      = load_rdataset(urls.mpg, fullfile(cacheDir, 'mpg.csv'));
Tecon     = load_rdataset(urls.economics, fullfile(cacheDir, 'economics.csv'));
Ttx       = load_rdataset(urls.txhousing, fullfile(cacheDir, 'txhousing.csv'));

caseResults = {};
caseId = 0;

caseId = caseId + 1;
caseResults{caseId} = fit_case(Tfaithful, true(height(Tfaithful),1), 'eruptions', 'waiting', ...
    'Faithful geyser', 'saturation', [35; 50; 0.5], [0;0;0], [200;200;10], []);

rng(0);
subset = randperm(height(Tdiamonds), 5000);
mask = false(height(Tdiamonds),1);
mask(subset) = true;
caseId = caseId + 1;
caseResults{caseId} = fit_case(Tdiamonds, mask, 'carat', 'price', ...
    'Diamonds', 'power', [5000;1.5], [0;0], [1e6;5], []);

mask = isfinite(Tmsleep.bodywt) & isfinite(Tmsleep.sleep_total);
caseId = caseId + 1;
caseResults{caseId} = fit_case(Tmsleep, mask, 'bodywt', 'sleep_total', ...
    'Mammal sleep', 'power', [10;-0.1], [0;-5], [100;5], []);

speciesList = {'Adelie','Chinstrap','Gentoo'};
for k = 1:numel(speciesList)
    mask = strcmp(string(Tpenguins.species), speciesList{k}) & ...
        isfinite(Tpenguins.flipper_length_mm) & isfinite(Tpenguins.body_mass_g);
    caseId = caseId + 1;
    caseResults{caseId} = fit_case(Tpenguins, mask, 'flipper_length_mm', 'body_mass_g', ...
        ['Penguins ' speciesList{k}], 'power', [1;1.5], [0;0], [1e6;5], []);
end

classes = {'pickup','subcompact','suv'};
for k = 1:numel(classes)
    mask = strcmp(string(Tmpg.class), classes{k}) & ...
        isfinite(Tmpg.displ) & isfinite(Tmpg.hwy);
    caseId = caseId + 1;
    caseResults{caseId} = fit_case(Tmpg, mask, 'displ', 'hwy', ...
        ['MPG ' classes{k}], 'expdecay', [15;20;0.5], [0;0;0], [100;100;10], []);
end

Tecon.t = days(datetime(string(Tecon.date)) - datetime(string(Tecon.date(1)))) / 365.25;
mask = isfinite(Tecon.t) & isfinite(Tecon.pce);
caseId = caseId + 1;
caseResults{caseId} = fit_case(Tecon, mask, 't', 'pce', ...
    'Economics PCE', 'expgrowth', [500;0.05], [0;0], [1e6;1], 't');

mask = strcmp(string(Ttx.city), 'Austin') & isfinite(Ttx.year) & isfinite(Ttx.median);
Taustin = groupsummary(Ttx(mask,:), 'year', 'mean', 'median');
Taustin.t = Taustin.year - min(Taustin.year);
caseId = caseId + 1;
caseResults{caseId} = fit_case(Taustin, true(height(Taustin),1), 't', 'mean_median', ...
    'Austin housing', 'expgrowth', [1e5;0.03], [0;0], [1e7;1], 't');

cases = [caseResults{:}];
summaryTable = struct2table(rmfield(cases, {'x','y','yhat','residuals','stdResiduals','cook'}));
disp(summaryTable(:, {'label','n','model','theta1','theta2','theta3','SSE','MSE','s2','SST','R2','maxAbsStdResidual','maxCook'}));

write_summary_csv(summaryTable, fullfile(outDir, 'matlab_nonlinear_summary.csv'));
make_overview_figure(cases, fullfile(outDir, 'matlab_nonlinear_cases_overview.png'));
make_diagnostic_figure(cases([1 2 10 11]), fullfile(outDir, 'matlab_nonlinear_diagnostics.png'));

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

function result = fit_case(T, mask, xvar, yvar, label, modelName, theta0, lb, ub, orderVar)
    D = T(mask, :);
    if ~isempty(orderVar)
        D = sortrows(D, orderVar);
    end
    x = double(D.(xvar));
    y = double(D.(yvar));

    model = get_model(modelName);
    opts = optimoptions('lsqcurvefit', 'Display', 'off', ...
        'MaxIterations', 1000, ...
        'MaxFunctionEvaluations', 50000, ...
        'FunctionTolerance', 1e-12, ...
        'StepTolerance', 1e-12);

    [thetaHat, ~, residuals, ~, ~, ~, J] = lsqcurvefit(model, theta0, x, y, lb, ub, opts);

    yhat = model(thetaHat, x);
    n = numel(y);
    p = numel(thetaHat);

    SSE = sum((y-yhat).^2);
    MSE = SSE / n;
    s2  = SSE / (n-p);
    SST = sum((y-mean(y)).^2);
    R2  = 1 - SSE / SST;

    J = full(J);
    JTJ = J' * J;
    H = J * pinv(full(JTJ)) * J';
    h = diag(H);

    s = sqrt(s2);
    stdResiduals = residuals ./ (s * sqrt(max(1-h, 1e-12)));
    cook = (residuals.^2 / (p*s2)) .* h ./ max((1-h).^2, 1e-12);

    thetaPad = nan(3,1);
    thetaPad(1:p) = thetaHat;

    result = struct();
    result.label = label;
    result.model = modelName;
    result.formula = model_formula(modelName);
    result.n = n;
    result.theta1 = thetaPad(1);
    result.theta2 = thetaPad(2);
    result.theta3 = thetaPad(3);
    result.SSE = SSE;
    result.MSE = MSE;
    result.s2 = s2;
    result.SST = SST;
    result.R2 = R2;
    result.maxAbsStdResidual = max(abs(stdResiduals));
    result.maxCook = max(cook);
    result.x = x;
    result.y = y;
    result.yhat = yhat;
    result.residuals = residuals;
    result.stdResiduals = stdResiduals;
    result.cook = cook;
end

function model = get_model(modelName)
    switch lower(modelName)
        case 'saturation'
            model = @(theta, x) theta(1) + theta(2) * (1 - exp(-theta(3) * x));
        case 'power'
            model = @(theta, x) theta(1) * x.^theta(2);
        case 'expdecay'
            model = @(theta, x) theta(1) + theta(2) * exp(-theta(3) * x);
        case 'expgrowth'
            model = @(theta, x) theta(1) * exp(theta(2) * x);
        otherwise
            error('Unknown model: %s', modelName);
    end
end

function txt = model_formula(modelName)
    switch lower(modelName)
        case 'saturation'
            txt = 'y = a + b(1-exp(-cx))';
        case 'power'
            txt = 'y = a*x^b';
        case 'expdecay'
            txt = 'y = a + b*exp(-cx)';
        case 'expgrowth'
            txt = 'y = a*exp(bx)';
    end
end

function write_summary_csv(T, filename)
    writetable(T, filename);
end

function make_overview_figure(cases, filename)
    figure('Color', 'w', 'Position', [100, 100, 1000, 1400]);
    nCases = numel(cases);
    for k = 1:nCases
        subplot(6, 2, k);
        x = cases(k).x;
        y = cases(k).y;
        scatter(x, y, 12, 'filled');
        hold on;

        xx = linspace(min(x), max(x), 300)';
        theta = [cases(k).theta1; cases(k).theta2; cases(k).theta3];
        if isnan(theta(3))
            theta = theta(1:2);
        end

        model = get_model(cases(k).model);
        yy = model(theta, xx);

        plot(xx, yy, 'r-', 'LineWidth', 1.8);
        title(cases(k).label, 'FontSize', 10);
        xlabel('x');
        ylabel('y');
        grid on;
    end
    if nCases < 12
        subplot(6, 2, 12);
        axis off;
    end
    exportgraphics(gcf, filename, 'Resolution', 180);
end

function make_diagnostic_figure(cases, filename)
    figure('Color', 'w', 'Position', [100, 100, 1100, 1200]);
    for k = 1:numel(cases)
        base = 3*(k-1);

        subplot(numel(cases), 3, base+1);
        scatter(cases(k).yhat, cases(k).residuals, 12, 'filled');
        yline(0, '--k');
        grid on;
        title([cases(k).label ' residuals']);
        xlabel('fitted');
        ylabel('residuals');

        subplot(numel(cases), 3, base+2);
        stem(cases(k).stdResiduals, 'filled');
        hold on;
        yline(3, ':r');
        yline(-3, ':r');
        yline(0, '--k');
        grid on;
        title('standardized residuals');
        xlabel('index');
        ylabel('r_i');

        subplot(numel(cases), 3, base+3);
        stem(cases(k).cook, 'filled');
        hold on;
        yline(4/cases(k).n, ':r');
        grid on;
        title('Cook distance');
        xlabel('index');
        ylabel('D_i');
    end
    exportgraphics(gcf, filename, 'Resolution', 180);
end