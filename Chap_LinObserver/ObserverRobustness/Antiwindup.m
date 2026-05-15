% =========================================================================
% Observer Anti-Windup Test under Actuator Saturation
% =========================================================================
clearvars; close all; clc;

set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% --- 1. System Parameters (DC Motor) ---
A = [0 1; 0 -10];
B = [0; 25];
C = [1 0];

% --- 2. Control and Observer Design ---
% Moderate controller and observer
K = place(A, B, [-4, -5]);
L = place(A', C', [-15, -20])';

% Actuator limit
u_max = 5; 

% --- 3. Simulation Setup (Common) ---
dt = 0.001;
t = 0:dt:3;
N = length(t);

%% ========================================================================
% SCENARIO 1: Closed-Loop Step Response
% ========================================================================
r = 2 * (t >= 0.1); % Step reference of 2 rad at t=0.1s

x = [10; -20];         % True Plant state
xhat_std = [0; 0];  % Standard Observer (Naïve)
xhat_aw  = [0; 0];  % Anti-Windup Observer

% History storage
x_hist = zeros(2, N);
xhat_std_hist = zeros(2, N);
xhat_aw_hist = zeros(2, N);
u_cmd_hist = zeros(1, N);
u_sat_hist = zeros(1, N);

% Simulation Loop 1
for k = 1:N
    y = C * x;
    
    x_hist(:,k) = x;
    xhat_std_hist(:,k) = xhat_std;
    xhat_aw_hist(:,k)  = xhat_aw;
    
    % Control Law
    u_cmd = -K * (xhat_aw - [r(k); 0]);
    u_sat = max(min(u_cmd, u_max), -u_max);
    
    u_cmd_hist(k) = u_cmd;
    u_sat_hist(k) = u_sat;
    
    % Plant Update (Receives SATURATED input)
    x = x + dt * (A*x + B*u_sat);
    
    % Standard Observer Update (Naively receives UNRESTRICTED command)
    xhat_std = xhat_std + dt * (A*xhat_std + B*u_cmd + L*(y - C*xhat_std));
    
    % Anti-Windup Observer Update (Correctly receives SATURATED command)
    xhat_aw = xhat_aw + dt * (A*xhat_aw + B*u_sat + L*(y - C*xhat_aw));
end

% --- Plotting Scenario 1 ---
figure('Color', 'w', 'Units', 'centimeters', 'Position', [2, 2, 16, 16], 'Name', 'Scenario 1: Step Response');
subplot(3,1,1);
plot(t, u_cmd_hist, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Commanded $u$'); hold on;
plot(t, u_sat_hist, 'b-', 'LineWidth', 2, 'DisplayName', 'Applied $u_{\rm sat}$');
yline(u_max, 'k:', 'LineWidth', 1.5, 'HandleVisibility', 'off');
yline(-u_max, 'k:', 'LineWidth', 1.5, 'HandleVisibility', 'off');
ylabel('Voltage (V)'); title('Scenario 1: Actuator Saturation (Step Response)');
legend('Location', 'northeast'); grid on;

subplot(3,1,2);
plot(t, x_hist(1,:), 'k-', 'LineWidth', 2, 'DisplayName', 'True $x_1$'); hold on;
plot(t, xhat_std_hist(1,:), 'r--', 'LineWidth', 1.5, 'DisplayName', 'Standard Obs');
plot(t, xhat_aw_hist(1,:), 'b:', 'LineWidth', 2, 'DisplayName', 'Anti-Windup Obs');
ylabel('Position (rad)'); title('Observer Position Tracking');
legend('Location', 'southeast'); grid on;

subplot(3,1,3);
plot(t, x_hist(2,:), 'k-', 'LineWidth', 2, 'DisplayName', 'True $x_2$'); hold on;
plot(t, xhat_std_hist(2,:), 'r--', 'LineWidth', 1.5, 'DisplayName', 'Standard Obs');
plot(t, xhat_aw_hist(2,:), 'b:', 'LineWidth', 2, 'DisplayName', 'Anti-Windup Obs');
ylabel('Velocity (rad/s)'); xlabel('Time (s)');
title('Observer Velocity Tracking');
legend('Location', 'southeast'); grid on;

exportgraphics(gcf, 'FigureAntiWindupFeedback.pdf', 'ContentType', 'vector');
%% ========================================================================
% SCENARIO 2: Open-Loop Sinusoidal Input (Amplitude > Saturation)
% ========================================================================
x = [0; 0];         
xhat_std = [0; 0];  
xhat_aw  = [0; 0];  

x_hist2 = zeros(2, N);
xhat_std_hist2 = zeros(2, N);
xhat_aw_hist2 = zeros(2, N);

% Generate Sinusoidal Command (Amplitude 10V, Limit 5V)
u_cmd_hist2 = 10 * sin(2*pi * 0.5 * t); % 0.5 Hz Sine wave
u_sat_hist2 = max(min(u_cmd_hist2, u_max), -u_max);

% Simulation Loop 2
for k = 1:N
    y = C * x;
    
    x_hist2(:,k) = x;
    xhat_std_hist2(:,k) = xhat_std;
    xhat_aw_hist2(:,k)  = xhat_aw;
    
    u_cmd = u_cmd_hist2(k);
    u_sat = u_sat_hist2(k);
    
    x = x + dt * (A*x + B*u_sat);
    xhat_std = xhat_std + dt * (A*xhat_std + B*u_cmd + L*(y - C*xhat_std));
    xhat_aw = xhat_aw + dt * (A*xhat_aw + B*u_sat + L*(y - C*xhat_aw));
end

% --- Plotting Scenario 2 ---
figure('Color', 'w', 'Units', 'centimeters', 'Position', [2, 2, 16, 16], 'Name', 'Scenario 2: Sinusoidal Input');
subplot(3,1,1);
plot(t, u_cmd_hist2, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Commanded $u$'); hold on;
plot(t, u_sat_hist2, 'b-', 'LineWidth', 2, 'DisplayName', 'Applied $u_{\rm sat}$');
yline(u_max, 'k:', 'LineWidth', 1.5, 'HandleVisibility', 'off');
yline(-u_max, 'k:', 'LineWidth', 1.5, 'HandleVisibility', 'off');
ylabel('Voltage (V)'); title('Scenario 2: Massive Sinusoidal Saturation');
legend('Location', 'northeast'); grid on;

subplot(3,1,2);
plot(t, x_hist2(1,:), 'k-', 'LineWidth', 2, 'DisplayName', 'True $x_1$'); hold on;
plot(t, xhat_std_hist2(1,:), 'r--', 'LineWidth', 1.5, 'DisplayName', 'Standard Obs');
plot(t, xhat_aw_hist2(1,:), 'b:', 'LineWidth', 2, 'DisplayName', 'Anti-Windup Obs');
ylabel('Position (rad)'); title('Observer Position Tracking');
legend('Location', 'southwest'); grid on;

subplot(3,1,3);
plot(t, x_hist2(2,:), 'k-', 'LineWidth', 2, 'DisplayName', 'True $x_2$'); hold on;
plot(t, xhat_std_hist2(2,:), 'r--', 'LineWidth', 1.5, 'DisplayName', 'Standard Obs');
plot(t, xhat_aw_hist2(2,:), 'b:', 'LineWidth', 2, 'DisplayName', 'Anti-Windup Obs');
ylabel('Velocity (rad/s)'); xlabel('Time (s)');
title('Observer Velocity Tracking');
legend('Location', 'southwest'); grid on;

exportgraphics(gcf, 'FigureAntiWindupOpenLoop.pdf', 'ContentType', 'vector');