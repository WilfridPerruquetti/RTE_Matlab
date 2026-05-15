% =========================================================================
% Observer Pole Placement vs. Noise Amplification
% =========================================================================
clear; clc; close all;

% --- Set LaTeX rendering as default for all figure text ---
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Plant: second-order stable system
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];

% Two observer tunings
poles_moderate = [-5 -6];
poles_fast     = [-25 -30];
L_moderate = place(A', C', poles_moderate)';
L_fast     = place(A', C', poles_fast)';

% Simulation parameters
T = 8;
dt = 1e-3;
t = 0:dt:T;
N = length(t);
u = ones(1, N);
sigma_v = 0.03;          % measurement-noise standard deviation
rng(1);                  % reproducible noise realization

% Initial conditions
x = [1; 0];
xhat_moderate = [0; 0];
xhat_fast = [0; 0];

X = zeros(2, N);
Xhat_moderate = zeros(2, N);
Xhat_fast = zeros(2, N);
Ymeas = zeros(1, N);

for k = 1:N
    % Noisy measurement
    y = C*x;
    y_meas = y + sigma_v*randn;

    % Store data
    X(:, k) = x;
    Xhat_moderate(:, k) = xhat_moderate;
    Xhat_fast(:, k) = xhat_fast;
    Ymeas(k) = y_meas;

    % Plant and observer dynamics
    dx = A*x + B*u(k);
    dxhat_moderate = A*xhat_moderate + B*u(k) ...
        + L_moderate*(y_meas - C*xhat_moderate);
    dxhat_fast = A*xhat_fast + B*u(k) ...
        + L_fast*(y_meas - C*xhat_fast);

    % Euler integration
    x = x + dt*dx;
    xhat_moderate = xhat_moderate + dt*dxhat_moderate;
    xhat_fast = xhat_fast + dt*dxhat_fast;
end

% Root-mean-square estimation error after the transient
idx = t > 3;
err_moderate = X(:, idx) - Xhat_moderate(:, idx);
err_fast = X(:, idx) - Xhat_fast(:, idx);
rms_moderate = sqrt(mean(sum(err_moderate.^2, 1)));
rms_fast = sqrt(mean(sum(err_fast.^2, 1)));

% Display results in command window
disp('--------- RMS ESTIMATION ERROR ---------');
fprintf('Moderate observer poles: %.4f\n', rms_moderate);
fprintf('Fast observer poles    : %.4f\n', rms_fast);
disp('----------------------------------------');

% Plot first state estimate
figure('Color', 'w', 'Position', [100, 100, 800, 500]);

% Plot noisy measurement first so it stays in the background
plot(t, Ymeas, 'Color', [0.8 0.8 0.8], 'DisplayName', 'Noisy measurement $y(t)$'); hold on;

% Plot true state and estimates
plot(t, X(1, :), 'k', 'LineWidth', 1.5, 'DisplayName', 'True state $x_1(t)$'); 
plot(t, Xhat_moderate(1, :), 'b--', 'LineWidth', 1.5, 'DisplayName', 'Moderate observer $\hat{x}_1(t)$');
plot(t, Xhat_fast(1, :), 'r:', 'LineWidth', 1.5, 'DisplayName', 'Fast observer $\hat{x}_1(t)$');

grid on;
xlabel('Time $t$ (s)', 'FontSize', 12);
ylabel('Position / Estimate', 'FontSize', 12);

% Legend and Title (LaTeX interpreted automatically due to groot settings)
legend('Location', 'best', 'FontSize', 11);
title('Measurement Noise Amplification by Fast Observer Poles', 'FontSize', 14);
set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureNoise