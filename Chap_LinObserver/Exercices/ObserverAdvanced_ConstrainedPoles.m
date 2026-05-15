% =========================================================================
% Observer Design: State Estimation Comparison with Noise
% =========================================================================
clear; clc; close all;

% Configuration du rendu LaTeX
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% --- 1. System Definition (Double Integrator) ---
A = [0 1; 0 0]; 
B = [0; 1];
C = [1 0];

% --- 2. Design Definitions ---
designs = struct('name', {'minimum', 'maximum', 'balanced'}, ...
    'poles', {[-1 -1.1], [-10 -10.1], [-3 -5]});

% --- 3. Simulation Parameters ---
dt = 1e-3; 
t = 0:dt:5; 
sigma = 0.02; % Bruit de mesure
rng(2);

% Initialisation des états
x_true = [0.5; 0.2]; % État réel initial du système
x_est = struct();
for i=1:3, x_est(i).val = [0; 0]; end % Observateurs partent de zero

% Stockage
X_hist = zeros(2, numel(t));
X_est_hist = repmat({zeros(2, numel(t))}, 1, 3);
E_norm_hist = zeros(3, numel(t));

% --- 4. Simulation Loop ---
for k = 1:numel(t)
    % Commande (sinusoïdale pour voir la poursuite)
    u = sin(2*t(k));
    
    % Système Réel (Plant) - Évolution sans bruit
    dx = A * x_true + B * u;
    x_true = x_true + dt * dx;
    X_hist(:,k) = x_true;
    
    % Mesure bruitée envoyée aux observateurs
    y_noisy = C * x_true + sigma * randn;
    
    % Mise à jour de chaque observateur
    for i = 1:numel(designs)
        L = place(A', C', designs(i).poles)';
        
        % Dynamique de l'observateur
        dx_hat = A * x_est(i).val + B * u + L * (y_noisy - C * x_est(i).val);
        x_est(i).val = x_est(i).val + dt * dx_hat;
        
        % Sauvegarde
        X_est_hist{i}(:,k) = x_est(i).val;
        E_norm_hist(i,k) = norm(x_true - x_est(i).val);
    end
end

% --- 5. Figure 1 : Convergence de la norme de l'erreur ---
figure('Color', 'w', 'Units', 'centimeters', 'Position', [2, 2, 16, 10]);
for i=1:3
    semilogy(t, E_norm_hist(i,:), 'LineWidth', 1.5, 'DisplayName', designs(i).name); hold on;
end
grid on; xlabel('Time $t$ (s)'); ylabel('$\|e(t)\|$');
title('Observer Error Convergence (Log Scale)');
legend('Location', 'best');
exportgraphics(gcf, 'FigureObserverErrorNorm.pdf', 'ContentType', 'vector');

% --- 6. Figure 2 : Comparaison des estimations (État x1 et x2) ---
figure('Color', 'w', 'Units', 'centimeters', 'Position', [18, 2, 18, 12]);
titles = {'Position $x_1$', 'Velocity $x_2$'};
for j = 1:2
    subplot(2,1,j);
    plot(t, X_hist(j,:), 'k', 'LineWidth', 2, 'DisplayName', 'True State'); hold on;
    for i = 1:3
        plot(t, X_est_hist{i}(j,:), '--', 'DisplayName', designs(i).name);
    end
    grid on; ylabel(titles{j});
    if j==1, legend('Location', 'best', 'Orientation', 'horizontal'); end
end
xlabel('Time $t$ (s)');
exportgraphics(gcf, 'FigureStateEstimationCompare.pdf', 'ContentType', 'vector');