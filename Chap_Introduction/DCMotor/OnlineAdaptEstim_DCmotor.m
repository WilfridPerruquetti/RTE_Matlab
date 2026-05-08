% =========================================================
% EX2 - Online adaptive estimation: DC motor in position
% System: J*ddot_theta + b*dot_theta = K_m * u
% Rewritten as: ddot_y + a1*dot_y = a2*u
% True parameters: a1 = b/J = 2.0, a2 = Km/J = 5.0
% =========================================================
clear; clc; close all;

%% --- Physical parameters (true values) ---
J   = 0.1;    % inertia [kg.m^2]
b   = 0.2;    % viscous friction [N.m.s/rad]
Km  = 0.5;    % motor gain [N.m/V]

a1_true = b/J;   % = 2.0
a2_true = Km/J;  % = 5.0

%% --- Simulation parameters ---
Ts  = 0.01;          % sampling period [s]
T   = 30;            % total duration [s]
t   = (0:Ts:T)';
N   = length(t);

%% --- Persistently exciting input: multisine ---
% Contains 5 frequencies => sufficiently rich for 2 parameters
u = 2*sin(2*pi*1.0*t) + 1.5*sin(2*pi*2.5*t) + ...
    1.0*sin(2*pi*0.5*t) + 0.8*cos(2*pi*1.8*t) + ...
    0.5*sin(2*pi*3.2*t);

%% --- Generate true system output (2nd order) via ODE ---
% State: x = [theta; dot_theta]
% x_dot = [dot_theta; -a1*dot_theta + a2*u]
A_sys = [0, 1; 0, -a1_true];
B_sys = [0; a2_true];
C_sys = [1, 0];
sys_c = ss(A_sys, B_sys, C_sys, 0);
sys_d = c2d(sys_c, Ts, 'zoh');

x    = zeros(2, N);  % [theta; dot_theta]
y    = zeros(N, 1);  % position output (noisy)
y_true = zeros(N, 1);

noise_level = 0.02;
rng(42);
noise = noise_level * randn(N, 1);

for k = 2:N
    x(:,k)   = sys_d.A * x(:,k-1) + sys_d.B * u(k-1);
    y_true(k) = C_sys * x(:,k);
end
y = y_true + noise;

%% --- Build regressor using auxiliary filters ---
% Lambda(s) = s^2 + lambda1*s + lambda0 (stable)
lambda0 = 4.0;
lambda1 = 4.0;   % poles at s = -2 (double)

% Realise filters via state-space: omega_dot = A_lam*omega + b*signal
A_lam = [0, 1; -lambda0, -lambda1];
b_lam = [0; 1];

% Two auxiliary filters: driven by u and by y
omega_u = zeros(2, N);   % filter of u
omega_y = zeros(2, N);   % filter of y

for k = 2:N
    omega_u(:,k) = omega_u(:,k-1) + Ts*(A_lam*omega_u(:,k-1) + b_lam*u(k-1));
    omega_y(:,k) = omega_y(:,k-1) + Ts*(A_lam*omega_y(:,k-1) + b_lam*y(k-1));
end

% Regressor phi = [phi1; phi2] where:
% phi1 = filtered(-dot_y) ~ -(s/Lambda)*y  => -omega_y(2,:)  [second state]
% phi2 = filtered(u)      ~ (1/Lambda)*u   =>  omega_u(1,:)  [first state]
% Output equation: (1/Lambda)*ddot_y = phi^T * theta
% Measured output: z = (1/Lambda)*y
phi   = zeros(2, N);
phi(1,:) = -omega_y(2,:);      % regressor for a1 (friction term)
phi(2,:) =  omega_u(1,:);      % regressor for a2 (input term)
z_meas   =  omega_y(1,:)';     % filtered output (left-hand side)

%% --- Gradient adaptation law ---
Gamma = 5 * eye(2);             % adaptation gain matrix
theta_hat = zeros(2, N);        % initial estimate = 0
e_sig     = zeros(N, 1);        % estimation error

for k = 2:N
    phi_k   = phi(:,k);
    e_sig(k) = phi_k' * theta_hat(:,k-1) - z_meas(k);
    theta_hat(:,k) = theta_hat(:,k-1) - Ts * Gamma * phi_k * e_sig(k);
end

a1_hat = theta_hat(1,:);
a2_hat = theta_hat(2,:);

%% --- Reconstructed output using estimated parameters ---
a1_fin  = a1_hat(end);
a2_fin  = a2_hat(end);
A_est   = [0, 1; 0, -a1_fin];
B_est   = [0; a2_fin];
sys_est = ss(A_est, B_est, C_sys, 0);
sys_est_d = c2d(sys_est, Ts, 'zoh');

x_est = zeros(2, N);
y_est = zeros(N, 1);
for k = 2:N
    x_est(:,k) = sys_est_d.A * x_est(:,k-1) + sys_est_d.B * u(k-1);
    y_est(k)   = C_sys * x_est(:,k);
end

R2 = 1 - sum((y - y_est).^2) / sum((y - mean(y)).^2);
fprintf('Final estimates:  a1_hat = %.4f (true: %.1f),  a2_hat = %.4f (true: %.1f)\n',...
    a1_fin, a1_true, a2_fin, a2_true);
fprintf('R2 on full record = %.5f\n', R2);

%% --- Figure 1: Input signal ---
figure('Name','EX2 - Input signal');
plot(t, u, 'b', 'LineWidth', 1.2);
grid on; xlabel('Time [s]'); ylabel('u(t) [V]');
title('Persistently exciting multisine input');

%% --- Figure 2: System output (measured vs true) ---
figure('Name','EX2 - Output');
plot(t, y_true, 'b', 'LineWidth', 1.4); hold on;
plot(t, y,      'r', 'LineWidth', 0.8, 'Color', [0.8 0.2 0.2]);
grid on; xlabel('Time [s]'); ylabel('\theta(t) [rad]');
legend('True output','Noisy measurement','Location','best');
title('DC motor position output');

%% --- Figure 3: Parameter convergence ---
figure('Name','EX2 - Parameter convergence');
subplot(2,1,1);
plot(t, a1_hat, 'b', 'LineWidth', 1.4); hold on;
yline(a1_true, 'r--', 'LineWidth', 1.5);
grid on; ylabel('\hat{a}_1(t)');
legend('Estimate','True value','Location','best');
title('Convergence of parameter estimates');

subplot(2,1,2);
plot(t, a2_hat, 'b', 'LineWidth', 1.4); hold on;
yline(a2_true, 'r--', 'LineWidth', 1.5);
grid on; xlabel('Time [s]'); ylabel('\hat{a}_2(t)');
legend('Estimate','True value','Location','best');

%% --- Figure 4: Estimation error e(t) ---
figure('Name','EX2 - Estimation error');
plot(t, e_sig, 'b', 'LineWidth', 1.2);
grid on; xlabel('Time [s]'); ylabel('e(t)');
title('Output estimation error e(t) = \phi^\top\hat\theta - z');

%% --- Figure 5: Output reconstruction ---
figure('Name','EX2 - Output reconstruction');
plot(t, y,     'r', 'LineWidth', 0.8, 'Color', [0.8 0.2 0.2]); hold on;
plot(t, y_est, 'b--', 'LineWidth', 1.5);
grid on; xlabel('Time [s]'); ylabel('\theta(t) [rad]');
legend('Noisy measurement','Reconstructed output (\hat\theta_{final})','Location','best');
title(sprintf('Output reconstruction  (R^2 = %.4f)', R2));

%% --- Figure 6: Poor excitation comparison (constant input) ---
u_poor = 2 * ones(N, 1);

omega_u2 = zeros(2,N);
omega_y2 = zeros(2,N);
for k = 2:N
    omega_u2(:,k) = omega_u2(:,k-1) + Ts*(A_lam*omega_u2(:,k-1) + b_lam*u_poor(k-1));
    omega_y2(:,k) = omega_y2(:,k-1) + Ts*(A_lam*omega_y2(:,k-1) + b_lam*y(k-1));
end
phi2      = zeros(2,N);
phi2(1,:) = -omega_y2(2,:);
phi2(2,:) =  omega_u2(1,:);
z2        =  omega_y2(1,:)';

theta_hat2 = zeros(2,N);
for k = 2:N
    phi_k2         = phi2(:,k);
    e2             = phi_k2' * theta_hat2(:,k-1) - z2(k);
    theta_hat2(:,k)= theta_hat2(:,k-1) - Ts * Gamma * phi_k2 * e2;
end

figure('Name','EX2 - PE comparison');
subplot(2,1,1);
plot(t, a1_hat,        'b',  'LineWidth', 1.4); hold on;
plot(t, theta_hat2(1,:),'r--','LineWidth', 1.4);
yline(a1_true, 'k:', 'LineWidth', 1.2);
grid on; ylabel('\hat{a}_1(t)');
legend('Multisine (PE)','Constant input (non-PE)','True value','Location','best');
title('Effect of excitation richness on convergence');

subplot(2,1,2);
plot(t, a2_hat,        'b',  'LineWidth', 1.4); hold on;
plot(t, theta_hat2(2,:),'r--','LineWidth', 1.4);
yline(a2_true, 'k:', 'LineWidth', 1.2);
grid on; xlabel('Time [s]'); ylabel('\hat{a}_2(t)');
legend('Multisine (PE)','Constant input (non-PE)','True value','Location','best');
