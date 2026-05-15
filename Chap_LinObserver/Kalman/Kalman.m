clear; clc; close all;

% Set default interpreters to LaTeX
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% --- Continuous System Matrices ---
A = [-0.5, 0.5; 0.5, -1.0];
B = [1; 0];
C = [1, 0];
dt = 0.01; 
t = 0:dt:30; 
N = length(t);

% --- Discretization (Exact ZOH) ---
sys_c = ss(A, B, C, 0);
sys_d = c2d(sys_c, dt);
Ad = sys_d.A;
Bd = sys_d.B;
Cd = sys_d.C;

% --- Noise Configuration ---
Q = 0.05 * eye(2); 
R = 0.02*10;          

% --- Kalman Gain (Discrete-time) ---
% Using 'dlqe' is safer for observer gains L.
% If you don't have the Control System Toolbox, we force the dimensions of L_kalman.
[~, L_temp, ~] = dlqr(Ad', Cd', Q, R);
L_kalman = L_temp(1, :)'; % Force into a 2x1 column vector

% --- Luenberger Gain ---
poles_target = [0.85, 0.90]; 
L_luen = place(Ad', Cd', poles_target)'; % Already a 2x1 column vector

% --- Simulation Initialization ---
x = zeros(2,N);     x(:,1) = [1; 0.5];
x_k = zeros(2,N);   x_k(:,1) = [0.8; 0.4]; 
x_l = zeros(2,N);   x_l(:,1) = [0.8; 0.4];

% Pre-generate noise
w = mvnrnd([0 0], Q, N)';
v = mvnrnd(0, R, N)';

% --- Simulation Loop ---
for k = 1:N-1
    u_k = 0.5 * sin(0.2*t(k)) + 0.5;
    
    % True system evolution
    x(:,k+1) = Ad * x(:,k) + Bd * u_k + w(:,k);
    
    % Measurement at k+1 (Scalar)
    y_meas = Cd * x(:,k+1) + v(k+1);
    
    % Prediction (A-priori)
    x_k_pred = Ad * x_k(:,k) + Bd * u_k;
    x_l_pred = Ad * x_l(:,k) + Bd * u_k;
    
    % Innovation (Force result to be a 1x1 scalar)
    inn_k = y_meas - Cd * x_k_pred;
    inn_l = y_meas - Cd * x_l_pred;
    
    % Update (A-posteriori)
    % Using L_kalman(:,1) ensures we are using the column vector properly
    x_k(:,k+1) = x_k_pred + L_kalman(:,1) * inn_k;
    x_l(:,k+1) = x_l_pred + L_luen(:,1) * inn_l;
end

% --- Performance Metrics ---
err_k = sqrt(sum((x - x_k).^2, 1));
err_l = sqrt(sum((x - x_l).^2, 1));

% --- Plotting ---
hFig = figure(10); 
clf(hFig);
set(hFig, 'Position', [100, 100, 900, 600], 'Color', 'w');

subplot(2,1,1);
plot(t, x(1,:), 'k', 'LineWidth', 1.2); hold on;
plot(t, x_k(1,:), 'b--', 'LineWidth', 1);
plot(t, x_l(1,:), 'r:', 'LineWidth', 1);
grid on; xlim([0 30]);
legend('Real State $x_1$', 'Kalman Filter', 'Luenberger Observer', 'Location', 'best');
ylabel('$x_1$ (m)');
title('$\mathrm{Long-term\ State\ Estimation\ Analysis}$');

subplot(2,1,2);
semilogy(t, err_k, 'b', 'LineWidth', 1.1); hold on;
semilogy(t, err_l, 'r', 'LineWidth', 1.1);
grid on; xlim([0 30]);
legend('Kalman RMSE', 'Luenberger RMSE', 'Location', 'best');
ylabel('$\|e\|_2$'); xlabel('Time (s)');
title('$\mathrm{Estimation\ Error\ Norm\ (Log\ Scale)}$');

shg; 
exportgraphics(hFig, 'ObserverComparison.pdf', 'ContentType', 'vector');