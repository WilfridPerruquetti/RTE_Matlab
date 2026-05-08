% =========================================================
% Ex.9 — Normalized LS: illustration of convergence properties
% System: y_k = phi_k^T * theta,  theta = [2; -1]
% Compare: gradient vs normalized gradient vs NLS
% =========================================================
clear; clc; close all;

%% --- Setup ---
theta_true = [2; -1];
p    = 2;
N    = 500;
kappa = 0.5;
rng(42);

% PE regressor: two frequencies
k_idx = (0:N-1)';
phi_all = [sin(0.5*k_idx), cos(1.2*k_idx)];   % 2 x N after transpose

% Generate clean output
y_clean = phi_all * theta_true;

%% --- Algorithm 1: Gradient ---
gamma_G = 0.8;
th_G    = zeros(p, N);
e_G     = zeros(N, 1);
for k = 2:N
    phi_k    = phi_all(k,:)';
    e_G(k)   = phi_k' * th_G(:,k-1) - y_clean(k);
    th_G(:,k)= th_G(:,k-1) - gamma_G * phi_k * e_G(k);
end

%% --- Algorithm 2: Normalized gradient ---
gamma_NG = 0.8;
th_NG    = zeros(p, N);
e_NG     = zeros(N, 1);
for k = 2:N
    phi_k    = phi_all(k,:)';
    m2       = kappa + phi_k'*phi_k;
    e_NG(k)  = phi_k'*th_NG(:,k-1) - y_clean(k);
    th_NG(:,k)= th_NG(:,k-1) - gamma_NG/m2 * phi_k * e_NG(k);
end

%% --- Algorithm 3: Normalized LS ---
P_k  = 10 * eye(p);
th_NLS = zeros(p, N);
e_NLS  = zeros(N, 1);
P_trace = zeros(N, 1);
for k = 2:N
    phi_k     = phi_all(k,:)';
    m2        = kappa + phi_k'*P_k*phi_k;
    e_NLS(k)  = phi_k'*th_NLS(:,k-1) - y_clean(k);
    th_NLS(:,k)= th_NLS(:,k-1) - P_k*phi_k*e_NLS(k)/m2;
    P_k        = P_k - P_k*(phi_k*phi_k')*P_k/m2;
    P_trace(k) = trace(P_k);
end

%% --- Figure 1: Parameter convergence ---
figure('Name','Ex9 Fig1 - Parameter convergence');
subplot(2,1,1);
plot(th_G(1,1:40),   'b-',  'LineWidth',1.2); hold on;
plot(th_NG(1,1:40),  'r--', 'LineWidth',1.2);
plot(th_NLS(1,1:40), 'g:',  'LineWidth',1.8);
yline(theta_true(1),'k','LineWidth',1.0);
grid on;
ylabel('$\hat{\theta}_1(k)$','Interpreter','latex');
title('Parameter convergence (no noise)','Interpreter','latex');
legend('Gradient','Norm. gradient','Norm. LS','True value',...
    'Interpreter','latex','Location','best');

subplot(2,1,2);
plot(th_G(2,1:40),   'b-',  'LineWidth',1.2); hold on;
plot(th_NG(2,1:40),  'r--', 'LineWidth',1.2);
plot(th_NLS(2,1:40), 'g:',  'LineWidth',1.8);
yline(theta_true(2),'k','LineWidth',1.0);
grid on;
xlabel('Sample $k$','Interpreter','latex');
ylabel('$\hat{\theta}_2(k)$','Interpreter','latex');

%% --- Figure 2: P_k trace (monotone decrease) ---
figure('Name','Ex9 Fig2 - trace(P_k)');
semilogy(P_trace(2:end),'b','LineWidth',1.4);
grid on;
xlabel('Sample $k$','Interpreter','latex');
ylabel('$\mathrm{tr}(P_k)$','Interpreter','latex');
title('Monotone decrease of $\mathrm{tr}(P_k)$ (NLS algorithm)','Interpreter','latex');

%% --- Figure 3: Estimation error norm ---
err_G   = sqrt(sum((th_G   - theta_true).^2, 1));
err_NG  = sqrt(sum((th_NG  - theta_true).^2, 1));
err_NLS = sqrt(sum((th_NLS - theta_true).^2, 1));

figure('Name','Ex9 Fig3 - Error norm');
semilogy(err_G,   'b-',  'LineWidth',1.2); hold on;
semilogy(err_NG,  'r--', 'LineWidth',1.2);
semilogy(err_NLS, 'g:',  'LineWidth',1.8);
grid on;
xlabel('Sample $k$','Interpreter','latex');
ylabel('$\|\tilde{\theta}_k\|$','Interpreter','latex');
title('Parameter error norm vs.\ sample index','Interpreter','latex');
legend('Gradient','Norm. gradient','Norm. LS','Interpreter','latex','Location','best');

fprintf('Final errors:\n');
fprintf('  Gradient:        ||theta_tilde|| = %.6f\n', err_G(end));
fprintf('  Norm. gradient:  ||theta_tilde|| = %.6f\n', err_NG(end));
fprintf('  Norm. LS:        ||theta_tilde|| = %.6f\n', err_NLS(end));
