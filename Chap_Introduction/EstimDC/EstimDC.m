% =========================================================================
% SCRIPT 1: DC Motor State Estimation via Observer
% =========================================================================
clear all; close all; clc;

%% 1. Simulation parameters
fs = 40000;             % Sampling frequency 40 kHz
dt = 1/fs;              % Sampling period
T = 2.5;                % Simulation duration (s)
t = (0:dt:T)';          % Time vector
N = length(t);

% Nominal motor values (assumed known here for simulation purposes)
tau = 0.0090173;   
k = 0.62514;       

% Input u(t) = 0.1 * sin(10t)
u = 0.1 * sin(10*t);

%% 2. Real system simulation
theta_true = zeros(N,1);
omega_true = zeros(N,1);

for i = 1:N-1
    % Model: tau * d_omega + omega = k * u
    omega_dot = (-omega_true(i) + k * u(i)) / tau;
    
    % Euler integration
    omega_true(i+1) = omega_true(i) + dt * omega_dot;
    theta_true(i+1) = theta_true(i) + dt * omega_true(i);
end

% Adding measurement noise (Position sensor)
noise_std = 0.0005; % Noise standard deviation
y_meas = theta_true + noise_std * randn(N,1);

%% 3. State Observer (Levant's Differentiator / Super-Twisting)
% Objective: Reconstruct theta (z1) and omega (z2) from y_meas
z1 = zeros(N,1);
z2 = zeros(N,1);

% Initialization of the estimated position with the first measurement
z1(1) = y_meas(1); 

% Observer parameters
% L is an upper bound of the angular acceleration (ddot_theta)
L = 5; 
l1 = 1.5 * sqrt(L);
l2 = 1.1 * L;

for i = 1:N-1
    % Position estimation error
    e = y_meas(i) - z1(i);
    
    % Nonlinear functions h1 and h2
    h1_e = -sqrt(abs(e)) * sign(e);
    h2_e = -sign(e);
    
    % Observer dynamics
    z1_dot = z2(i) - l1 * h1_e;
    z2_dot =       - l2 * h2_e;
    
    % Euler integration
    z1(i+1) = z1(i) + dt * z1_dot;
    z2(i+1) = z2(i) + dt * z2_dot;
end

%% 4. Plotting results
figure('Name', 'State Estimation', 'Position', [100 100 900 700]);

% --- Plot 1: Position (Showing noise) ---
subplot(2,1,1);
plot(t, y_meas, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); hold on;
plot(t, theta_true, 'b', 'LineWidth', 2);
plot(t, z1, 'r--', 'LineWidth', 1.5);
xlim([0 T]); 
title('Angular Position Estimation $\theta$', 'Interpreter','latex');
xlabel('Time (s)','Interpreter','latex'); ylabel('Position $\theta$ (rad)','Interpreter','latex');
legend('Noisy measurement ($y$)', 'True position ($\theta$)', 'Estimated position ($z_1$)','Interpreter','latex', 'Location', 'NorthWest');
grid on;

% --- Zoom to highlight the noise ---
axes('Position',[.6 .65 .25 .25])
box on;
idx_zoom = (t > 1.0) & (t < 1.05); % Zoom on a small interval
plot(t(idx_zoom), y_meas(idx_zoom), 'Color', [0.7 0.7 0.7]); hold on;
plot(t(idx_zoom), theta_true(idx_zoom), 'b', 'LineWidth', 2);
plot(t(idx_zoom), z1(idx_zoom), 'r--', 'LineWidth', 1.5);
title('Zoom on noise');
grid on;

% --- Plot 2: Angular Velocity ---
subplot(2,1,2);
plot(t, omega_true, 'b', 'LineWidth', 2); hold on;
plot(t, z2, 'r', 'LineWidth', 1.5);
xlim([0 T]); ylim([min(omega_true)-0.5 max(omega_true)+0.5]);
title('Angular Velocity Estimation $\omega$','Interpreter','latex');
xlabel('Time (s)','Interpreter','latex'); ylabel('Velocity $\omega$ (rad/s)','Interpreter','latex');
legend('True velocity ($\omega$)', 'Estimated velocity ($z_2$) via Observer','Interpreter','latex');
grid on;

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureEstimaStates
