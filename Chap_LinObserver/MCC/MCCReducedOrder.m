clear; clc; close all;
set(groot, 'defaultTextInterpreter', 'latex');

% --- Motor Parameters ---
tau = 0.1; kp = 2.5;
A = [0 1; 0 -10];
B = [0; 25];
C = [1 0];

% --- Improved Observer Design ---
% Desired pole = -100 => Lr = 90
Lr = 5; 

% --- Simulation Parameters ---
dt = 0.0005; 
t = 0:dt:0.5;
N = length(t);

% Noise levels
sigma_noise = 0.01; % Standard deviation of encoder noise

% --- Initialization ---
x = [0; 0];           % Real motor [position; velocity]
z = 0.2;        % Initial observer state (with significant initial error)
history = zeros(N, 4); % [True_x2, Est_x2, True_x1, Measured_y]

for k = 1:N
    u = 1.0; % Step input
    
    % 1. Real System (Euler Integration)
    dx = A*x + B*u;
    x = x + dx*dt;
    
    % 2. Noisy Measurement (Position)
    y_noisy = C*x + sigma_noise * randn();
    
    % 3. Output Reconstruction (Algebraic Step)
    x2_hat = z + Lr * y_noisy;
    
    % 4. Observer Internal State Update (dz)
    dz = (-10 - Lr)*z - Lr*(10 + Lr)*y_noisy + 25*u;
    z = z + dz*dt;
    
    history(k, :) = [x(2), x2_hat, x(1), y_noisy];
end

% --- Plotting ---
figure('Color', 'w', 'Position', [100, 100, 900, 700]);

% Subplot 1: Measured Output (Position)
subplot(2,1,1);
plot(t, history(:,3), 'k', 'LineWidth', 1.5); hold on;
plot(t, history(:,4), 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5);
grid on;
title('\textbf{Measured Output: Motor Position} $\theta$', 'FontSize', 13);
legend('True Position $x_1$', 'Measured $y$ (Noisy)', 'Location', 'southeast');
ylabel('Position (rad)');

% Subplot 2: Velocity Estimation
subplot(2,1,2);
plot(t, history(:,1), 'k', 'LineWidth', 1.5); hold on;
plot(t, history(:,2), 'r--', 'LineWidth', 1);
grid on;
title('\textbf{Reduced-Order Observer: Velocity Estimation} $\dot{\theta}$', 'FontSize', 13);
legend('True Velocity $x_2$', 'Estimated $\hat{x}_2$', 'Location', 'southeast');
xlabel('Time (s)'); ylabel('Velocity (rad/s)');

% Save for LaTeX
exportgraphics(gcf, 'MCCReducedOrderNoiseAnalysis.pdf', 'ContentType', 'vector');