% =========================================================================
% Observability Analysis and Sensor Selection
% Comparison: Full Output (y1, y2) vs. Single Output (y1 only)
% =========================================================================
clear; clc; close all;

% Configuration du rendu LaTeX
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% --- 1. Définition du Système ---
A = [0 1 0; -1 -0.5 0.3; 0 0 -2];
B = [0; 0; 1]; % On ajoute une entrée pour la dynamique
C = [1 0 0; 0 1 0];
polesObs = [-2.1 -3 -4]; % Pôles distincts pour place()

% Analyse d'observabilité
O = obsv(A,C);
fprintf('Rank with full C (y1, y2): %d\n', rank(O));

C1 = [1 0 0];
O1 = obsv(A,C1);
fprintf('Rank with y1 only: %d\n', rank(O1));

% --- 2. Conception de l'Observateur (Full C) ---
% On conçoit l'observateur pour le cas où le système est observable
L = place(A', C', polesObs)';

% --- 3. Simulation ---
dt = 1e-3;
t = 0:dt:5;
N = length(t);

% Initialisation
x = [0.5; -0.2; 0.8];    % État réel initial
xhat = [0; 0; 0];        % Estimation initiale
u = @(t) 2*sin(2*t);     % Entrée de commande

X_hist = zeros(3, N);
Xhat_hist = zeros(3, N);

for k = 1:N
    tk = t(k);
    uk = u(tk);
    y = C * x; % Mesure réelle (2 capteurs)
    
    % Stockage
    X_hist(:,k) = x;
    Xhat_hist(:,k) = xhat;
    
    % Évolution du système (Euler)
    dx = A*x + B*uk;
    x = x + dt*dx;
    
    % Évolution de l'observateur (Utilise les pôles placés)
    % dx_hat = A*xhat + B*u + L*(y - C*xhat)
    dxhat = A*xhat + B*uk + L*(y - C*xhat);
    xhat = xhat + dt*dxhat;
end

% --- 4. Plotting ---
figure('Color', 'w', 'Units', 'centimeters', 'Position', [2, 2, 18, 14]);

titles = {'State $x_1$ (Measured)', 'State $x_2$ (Measured)', 'State $x_3$ (Unmeasured)'};
for i = 1:3
    subplot(3, 1, i);
    plot(t, X_hist(i,:), 'k', 'LineWidth', 1.5, 'DisplayName', 'True State'); hold on;
    plot(t, Xhat_hist(i,:), 'r--', 'LineWidth', 1.2, 'DisplayName', 'Observer');
    grid on; ylabel(titles{i});
    if i == 1
        legend('Location', 'northeast', 'Orientation', 'horizontal');
        title('Observer Performance with Full Observability');
    end
end
xlabel('Time $t$ (s)');

% --- 5. Exportation ---
exportgraphics(gcf, 'FigureObservabilityAnalysis.pdf', 'ContentType', 'vector');

% --- 6. Diagnostic Final ---
fprintf('\nObserver Gain L:\n'); disp(L);
fprintf('Closed-loop poles (A-LC):\n'); disp(eig(A-L*C));