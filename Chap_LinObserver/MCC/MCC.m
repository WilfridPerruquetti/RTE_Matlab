% =========================================================================
% DC Motor Observer: Error Convergence for Multiple Initial Conditions
% =========================================================================
clear; clc; close all;

% --- Paramètres globaux pour forcer LaTeX partout ---
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% --- 1. Motor Parameters ---
kp = 1.5;    
tau = 0.05;  

% State Space Matrices
A = [0 1; 0 -1/tau];
B = [0; kp/tau];
C = [1 0];

% --- 2. Observer Design ---
zeta = 0.7;
omega_n = 290;

% Analytical gains
l1 = 2*zeta*omega_n - 1/tau;
l2 = omega_n^2 - l1/tau;
L = [l1; l2];

% --- 3. Simulation Setup ---
tspan = 0:0.0001:0.05; 
u = @(t) 10 * (t >= 0); % Step input

% True system initial condition (starts at 0)
x0 = [0; 0];          

% Define the three initial conditions for the observer
xhat0_cases = {
    [1; 0], ... % Case 1: Position error only
    [0; 1], ... % Case 2: Velocity error only
    [1; 1]  ... % Case 3: Combined error
};

% Plotting styles
colors = {'b', 'r', '#009900'}; % Blue, Red, Green

% AJOUT DES $ POUR QUE LATEX COMPILE CORRECTEMENT LES MATHS
labels = {
    '$e_x(0) = [1, 0]^\top$ (position)', ...
    '$e_x(0) = [0, 1]^\top$ (velocity)', ...
    '$e_x(0) = [1, 1]^\top$ (combined)'
};

% Prepare the figure
figure('Name', 'Observer Error Convergence', 'Color', 'w', 'Position', [150, 150, 800, 500]);
hold on; grid on;

% --- 4. Run Simulations & Plot ---
for i = 1:length(xhat0_cases)
    xhat0 = xhat0_cases{i};
    X0 = [x0; xhat0];
    
    % Augmented dynamics ODE
    sys_ode = @(t, X) [
        A * X(1:2) + B * u(t);
        A * X(3:4) + B * u(t) + L * C * (X(1:2) - X(3:4))
    ];
    
    % Run ode45
    [t_out, X_out] = ode45(sys_ode, tspan, X0);
    
    % Extract true state and estimated state
    x_true = X_out(:, 1:2);
    x_est  = X_out(:, 3:4);
    
    % Calculate the estimation error e(t)
    e = x_true - x_est;
    
    % Calculate the Euclidean norm ||e(t)||
    norm_e = vecnorm(e, 2, 2);
    
    % Plot the norm curve (Retrait de 'interpreter' ici)
    plot(t_out, norm_e, 'Color', colors{i}, 'LineWidth', 2, 'DisplayName', labels{i});
end

% --- 5. Formatting the Figure ---
% Les textes sont maintenant encadrés correctement avec des $ pour les variables
title('DC Motor Observer: Error Convergence', 'FontSize', 14);
xlabel('Time (s)', 'FontSize', 12);
ylabel('Estimation Error $\|e_x(t)\|$', 'FontSize', 12);

% Add zero-line reference
yline(0, 'k:', 'LineWidth', 1.5, 'HandleVisibility', 'off');

legend('Location', 'northeast', 'FontSize', 11);
set(gca, 'FontSize', 11);

set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureMCC
