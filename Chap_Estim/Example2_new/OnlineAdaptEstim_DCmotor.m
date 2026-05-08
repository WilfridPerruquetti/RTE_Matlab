% =========================================================
% EX2 - Online adaptive estimation: DC motor angular velocity
% System: dot_y + a1*y = a2*u,  y = omega(t) [rad/s]
% True params: a1 = b/J = 2.0, a2 = Km/J = 5.0
% =========================================================
clear; clc; close all;

%% --- Physical parameters ---
J   = 0.1;
b   = 0.2;
Km  = 0.5;
a1_true = b/J;    % 2.0
a2_true = Km/J;   % 5.0
fprintf('True parameters: a1 = %.1f, a2 = %.1f\n', a1_true, a2_true);

%% --- Simulation parameters ---
Ts = 0.01;
T  = 30;
t  = (0:Ts:T)';
N  = length(t);

%% --- Persistently exciting input: 5-frequency multisine ---
u = 2.0*sin(2*pi*1.0*t) + 1.5*sin(2*pi*2.5*t) + ...
    1.0*sin(2*pi*0.5*t) + 0.8*cos(2*pi*1.8*t) + ...
    0.5*sin(2*pi*3.2*t);

%% --- True system (ZOH discretisation) ---
A_sys = [0, 1; 0, -a1_true];
B_sys = [0; a2_true];
C_vel = [0, 1];
sys_d = c2d(ss(A_sys, B_sys, C_vel, 0), Ts, 'zoh');

x      = zeros(2, N);
y_true = zeros(N, 1);
for k = 2:N
    x(:,k)    = sys_d.A*x(:,k-1) + sys_d.B*u(k-1);
    y_true(k) = C_vel*x(:,k);
end
rng(42);
y = y_true + 0.01*randn(N, 1);

%% --- Auxiliary filters: Lambda(s) = s + 6 ---
lam0   = 6.0;
omg_y  = zeros(N,1);
omg_u  = zeros(N,1);
for k = 2:N
    omg_y(k) = omg_y(k-1) + Ts*(-lam0*omg_y(k-1) + y(k-1));
    omg_u(k) = omg_u(k-1) + Ts*(-lam0*omg_u(k-1) + u(k-1));
end

% Regression: z = phi^T * [a1; a2]
z_meas = y - lam0*omg_y;          % (s/Lambda)*y
phi    = [-omg_y, omg_u];         % [phi1, phi2]  (N x 2)

%% --- Gradient adaptation law ---
Gamma     = 10*eye(2);
theta_hat = zeros(N, 2);
e_sig     = zeros(N, 1);
for k = 2:N
    phi_k         = phi(k,:)';
    e_sig(k)      = phi_k'*theta_hat(k-1,:)' - z_meas(k);
    theta_hat(k,:)= theta_hat(k-1,:)' - Ts*Gamma*phi_k*e_sig(k);
end
a1_hat = theta_hat(:,1);
a2_hat = theta_hat(:,2);
a1_fin = a1_hat(end);
a2_fin = a2_hat(end);

fprintf('a1_hat = %.4f  (error %.2f%%)\n', a1_fin, abs(a1_fin-a1_true)/a1_true*100);
fprintf('a2_hat = %.4f  (error %.2f%%)\n', a2_fin, abs(a2_fin-a2_true)/a2_true*100);

%% --- Output reconstruction ---
sys_est = c2d(ss([0,1;0,-a1_fin],[0;a2_fin],C_vel,0), Ts,'zoh');
x_est   = zeros(2,N); y_est = zeros(N,1);
for k = 2:N
    x_est(:,k) = sys_est.A*x_est(:,k-1) + sys_est.B*u(k-1);
    y_est(k)   = C_vel*x_est(:,k);
end
R2 = 1 - sum((y-y_est).^2)/sum((y-mean(y)).^2);
fprintf('R2 = %.5f\n', R2);

%% --- Non-PE experiment: constant input ---
u_c  = 2*ones(N,1);
x_c  = zeros(2,N); y_c = zeros(N,1);
for k = 2:N
    x_c(:,k) = sys_d.A*x_c(:,k-1) + sys_d.B*u_c(k-1);
    y_c(k)   = C_vel*x_c(:,k);
end
y_c = y_c + 0.01*randn(N,1);

wy_c = zeros(N,1); wu_c = zeros(N,1);
for k = 2:N
    wy_c(k) = wy_c(k-1) + Ts*(-lam0*wy_c(k-1) + y_c(k-1));
    wu_c(k) = wu_c(k-1) + Ts*(-lam0*wu_c(k-1) + u_c(k-1));
end
phi_c  = [-wy_c, wu_c];
z_c    = y_c - lam0*wy_c;
th_c   = zeros(N,2);
for k = 2:N
    phi_ck   = phi_c(k,:)';
    e_c      = phi_ck'*th_c(k-1,:)' - z_c(k);
    th_c(k,:)= th_c(k-1,:)' - Ts*Gamma*phi_ck*e_c;
end

%% ============================================================
%  FIGURES  (Interpreter = latex for all text)
%  ============================================================

%% Figure 1: Input signal
figure('Name','EX2 Fig1');
plot(t, u, 'b', 'LineWidth', 1.2);
grid on;
xlabel('$t$ [s]', 'Interpreter','latex');
ylabel('$u(t)$ [V]', 'Interpreter','latex');
title('Persistently exciting multisine input', 'Interpreter','latex');
legend('$u(t)$: 5-frequency multisine', 'Interpreter','latex','Location','best');
saveas(gcf,'Figures/FigureInputSignal.pdf')

%% Figure 2: Output
figure('Name','EX2 Fig2');
plot(t, y_true, 'b', 'LineWidth', 1.6); hold on;
plot(t, y, 'Color',[0.8 0.2 0.2], 'LineWidth', 0.8);
grid on;
xlabel('$t$ [s]', 'Interpreter','latex');
ylabel('$\omega(t)$ [rad/s]', 'Interpreter','latex');
title('DC motor angular velocity output', 'Interpreter','latex');
legend('True $\omega(t)$', 'Noisy measurement', ...
       'Interpreter','latex', 'Location','best');

saveas(gcf,'Figures/FigureInputSignal.pdf');

%% Figure 3: Parameter convergence
figure('Name','EX2 Fig3');
subplot(2,1,1);
plot(t, a1_hat, 'b', 'LineWidth', 1.4); hold on;
yline(a1_true, 'r--', 'LineWidth', 1.5);
grid on;
ylabel('$\hat{a}_1(t)$', 'Interpreter','latex');
title('Convergence of parameter estimates', 'Interpreter','latex');
legend('$\hat{a}_1(t)$','True $a_1=2$','Interpreter','latex','Location','best');
ylim([-0.5, 3.0]);

subplot(2,1,2);
plot(t, a2_hat, 'b', 'LineWidth', 1.4); hold on;
yline(a2_true, 'r--', 'LineWidth', 1.5);
grid on;
xlabel('$t$ [s]',          'Interpreter','latex');
ylabel('$\hat{a}_2(t)$',   'Interpreter','latex');
legend('$\hat{a}_2(t)$','True $a_2=5$','Interpreter','latex','Location','best');
ylim([-0.5, 6.5]);

saveas(gcf,'Figures/FigureParameterConvergence.pdf')

%% Figure 4: Estimation error
figure('Name','EX2 Fig4');
plot(t, e_sig, 'b', 'LineWidth', 1.2);
grid on;
xlabel('$t$ [s]',                                          'Interpreter','latex');
ylabel('$e(t)$',                                           'Interpreter','latex');
title('Estimation error $e(t)=\phi^\top\hat{\theta}-z$',  'Interpreter','latex');

saveas(gcf,'Figures/FigureEstimationError.pdf')

%% Figure 5: Output reconstruction
figure('Name','EX2 Fig5');
plot(t, y,     'Color',[0.8 0.2 0.2],'LineWidth',0.8); hold on;
plot(t, y_est, 'b--', 'LineWidth', 1.8);
grid on;
xlabel('$t$ [s]',              'Interpreter','latex');
ylabel('$\omega(t)$ [rad/s]',  'Interpreter','latex');
title(sprintf('Output reconstruction ($R^2 = %.4f$)', R2), 'Interpreter','latex');
legend('Noisy measurement', ...
       sprintf('Reconstructed: $\\hat{\\theta}(T)$, $R^2=%.4f$', R2), ...
       'Interpreter','latex', 'Location','best');

saveas(gcf,['Figures/OutputReconstruction.pdf'])

%% Figure 6: PE comparison
figure('Name','EX2 Fig6');
subplot(2,1,1);
plot(t, a1_hat,    'b',   'LineWidth', 1.6); hold on;
plot(t, th_c(:,1), 'r--', 'LineWidth', 1.6);
yline(a1_true, 'k:', 'LineWidth', 1.2);
grid on;
ylabel('$\hat{a}_1(t)$', 'Interpreter','latex');
title('Effect of excitation richness on convergence', 'Interpreter','latex');
legend('Multisine (PE)','Constant input (non-PE)','True value', ...
       'Interpreter','latex','Location','best');
ylim([-0.5, 3.5]);

subplot(2,1,2);
plot(t, a2_hat,    'b',   'LineWidth', 1.6); hold on;
plot(t, th_c(:,2), 'r--', 'LineWidth', 1.6);
yline(a2_true, 'k:', 'LineWidth', 1.2);
grid on;
xlabel('$t$ [s]',          'Interpreter','latex');
ylabel('$\hat{a}_2(t)$',   'Interpreter','latex');
legend('Multisine (PE)','Constant input (non-PE)','True value', ...
       'Interpreter','latex','Location','best');
ylim([-0.5, 6.5]);

saveas(gcf,'Figures/PEComparison.pdf')