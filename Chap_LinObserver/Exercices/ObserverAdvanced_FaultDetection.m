% =========================================================================
% Fault Detection: Kalman Residual Analysis (Leak in Tank 1)
% =========================================================================
clear; clc; close all;

% Configuration du rendu LaTeX
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% --- 1. System Definition (Two-Tank System) ---
a1 = 0.6; a2 = 0.4; b = 1;
A = [-a1 0; a1 -a2]; 
B = [b; 0]; 
C = [0 1]; % On mesure le niveau du réservoir 2

% --- 2. Kalman Filter Design (Steady-State) ---
Q = 0.01*eye(2); 
R = 0.002;
[~,~,L] = care(A', C', Q, R); 
L = L';

% --- 3. Simulation Parameters ---
dt = 0.01; 
t = 0:dt:40; 
u = ones(size(t)); 
rng(3);

x = [0; 0]; 
xhat = [0; 0]; 
J = zeros(size(t));
r_raw = zeros(size(t));

% --- 4. Simulation Loop ---
for k = 1:numel(t)
    % Introduction d'un défaut (fuite) à t = 20s
    if t(k) < 20
        Atrue = A;
    else
        % Augmentation du coefficient de sortie du tank 1 (fuite)
        Atrue = [-(1.2*a1) 0; a1 -a2]; 
    end
    
    % Mesure bruitée
    y = C*x + sqrt(R)*randn;
    
    % Évolution du système réel (Plant)
    x = x + dt*(Atrue*x + B*u(k));
    
    % Évolution de l'observateur (Kalman)
    % L'observateur ignore le défaut (modèle nominal A)
    xhat = xhat + dt*(A*xhat + B*u(k) + L*(y - C*xhat));
    
    % Calcul du résidu
    res = y - C*xhat;
    r_raw(k) = res;
    J(k) = res^2; % Indicateur quadratique
end

% --- 5. Fault Detection Logic ---
% Calcul du seuil basé sur la période saine (t < 20s)
healthy_idx = t < 20;
J_mean = mean(J(healthy_idx));
J_std  = std(J(healthy_idx));
Jth = J_mean + 4*J_std; % Seuil de détection (4-sigma)

% Temps de détection
detection_idx = find(t >= 20 & J > Jth, 1, 'first');
if ~isempty(detection_idx)
    td = t(detection_idx);
    fprintf('Fault injected at 20.00s. Detection delay: %.2f s\n', td - 20);
else
    td = NaN;
    fprintf('Fault not detected.\n');
end

% --- 6. Plotting ---
figure('Color', 'w', 'Units', 'centimeters', 'Position', [2, 2, 16, 10]);

plot(t, J, 'Color', [0.7 0.7 0.7], 'DisplayName', 'Raw Residual $J(t)$'); hold on;
% Ajout d'une moyenne glissante pour la clarté
plot(t, movmean(J, 50), 'b', 'LineWidth', 1.5, 'DisplayName', 'Filtered Residual');
yline(Jth, 'r--', 'LineWidth', 2, 'DisplayName', 'Detection Threshold');
xline(20, 'k:', 'Leak Starts', 'LabelVerticalAlignment', 'bottom');

if ~isnan(td)
    plot(td, Jth, 'ro', 'MarkerSize', 8, 'LineWidth', 2, 'DisplayName', 'Detection Point');
end

grid on;
xlabel('Time $t$ (s)');
ylabel('Residual Indicator $J(t) = (y - C\hat{x})^2$');
title('Kalman Filter Based Leak Detection');
legend('Location', 'northeast');

% --- 7. Export ---
exportgraphics(gcf, 'FigureFaultDetectionKalman.pdf', 'ContentType', 'vector');