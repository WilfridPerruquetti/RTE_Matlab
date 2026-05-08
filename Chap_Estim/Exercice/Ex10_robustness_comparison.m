% =========================================================
% Ex.10 — Robustness to bounded noise
% System: dot_y + a0*y = b0*u  (a0=2, b0=1)
% Compare gradient vs normalized gradient under noise
% =========================================================
clear; clc; close all;

%% --- System parameters ---
a0_true = 2.0;
b0_true = 1.0;
theta_true = [b0_true; a0_true];   % theta = [b0; lam0-a0] but lam0=a0+2 here

%% --- Simulation parameters ---
Ts  = 0.005;
T   = 30.0;
t   = (0:Ts:T)';
N   = length(t);

%% --- PRBS-like multisine input (sufficiently rich) ---
u = 1.5*sin(2*pi*0.5*t) + sin(2*pi*1.3*t) + 0.5*sin(2*pi*2.1*t);

%% --- True system simulation (Euler) ---
lam0 = 4.0;   % Lambda(s) = s + lam0

y = zeros(N,1);
for k = 2:N
    y(k) = y(k-1) + Ts*(-a0_true*y(k-1) + b0_true*u(k-1));
end

%% --- Noise levels to compare ---
nu_bars = [0, 0.05, 0.15];
gamma   = 40.0;
kappa   = 1.0;

colors  = {'b', 'r', [0.5 0 0.5]};
labels  = {'$\bar\nu=0$ (no noise)', ...
           '$\bar\nu=0.05$', '$\bar\nu=0.15$'};

%% --- Run both algorithms for each noise level ---
results = struct();

for ni = 1:length(nu_bars)
    nu_bar = nu_bars(ni);
    rng(42 + ni);
    noise  = nu_bar * (2*rand(N,1) - 1);   % bounded uniform noise
    y_noisy = y + noise;

    % Build auxiliary filters
    wu = zeros(N,1); wy = zeros(N,1);
    for k = 2:N
        wu(k) = wu(k-1) + Ts*(-lam0*wu(k-1) + u(k-1));
        wy(k) = wy(k-1) + Ts*(-lam0*wy(k-1) + y_noisy(k-1));
    end
    phi = [wu, wy];   % N x 2
    z   = y_noisy;    % regression output

    % --- Gradient algorithm ---
    Gam = gamma * eye(2);
    th_G = zeros(N, 2);
    for k = 2:N
        phi_k    = phi(k,:)';
        e_k      = phi_k'*th_G(k-1,:)' - z(k);
        th_G(k,:)= th_G(k-1,:)' - Ts*Gam*phi_k*e_k;
    end
    a0_G = lam0 - th_G(:,2);
    b0_G = th_G(:,1);

    % --- Normalized gradient algorithm ---
    th_NG = zeros(N, 2);
    for k = 2:N
        phi_k     = phi(k,:)';
        m2        = 1 + kappa*(phi_k'*phi_k);
        e_k       = phi_k'*th_NG(k-1,:)' - z(k);
        th_NG(k,:)= th_NG(k-1,:)' - Ts*(Gam*phi_k*e_k)/m2;
    end
    a0_NG = lam0 - th_NG(:,2);
    b0_NG = th_NG(:,1);

    results(ni).a0_G  = a0_G;  results(ni).b0_G  = b0_G;
    results(ni).a0_NG = a0_NG; results(ni).b0_NG = b0_NG;
    results(ni).nu_bar = nu_bar;

    err_G  = sqrt((a0_G  - a0_true).^2 + (b0_G  - b0_true).^2);
    err_NG = sqrt((a0_NG - a0_true).^2 + (b0_NG - b0_true).^2);

    fprintf('nu_bar=%.2f | Gradient: final err=%.4f, max=%.4f | NormGrad: final err=%.4f, max=%.4f\n',...
        nu_bar, err_G(end), max(err_G(N/2:end)), err_NG(end), max(err_NG(N/2:end)));
end

%% --- Figure 1: a0 convergence for gradient ---
figure('Name','Ex10 Fig1 - Gradient convergence');
subplot(2,1,1);
for ni = 1:length(nu_bars)
    plot(t, results(ni).a0_G, 'Color',colors{ni}, 'LineWidth', 1.3); hold on;
end
yline(a0_true,'k--','LineWidth',1.2);
grid on;
ylabel('$\hat{a}_0(t)$','Interpreter','latex');
title('Standard gradient: $\hat{a}_0(t)$ for different noise levels','Interpreter','latex');
legend([labels, {'True $a_0$'}],'Interpreter','latex','Location','best');
ylim([-0.5 4.5]);

subplot(2,1,2);
for ni = 1:length(nu_bars)
    plot(t, results(ni).b0_G, 'Color',colors{ni}, 'LineWidth', 1.3); hold on;
end
yline(b0_true,'k--','LineWidth',1.2);
grid on;
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$\hat{b}_0(t)$','Interpreter','latex');
ylim([-0.5 2.5]);

%% --- Figure 2: normalized gradient ---
figure('Name','Ex10 Fig2 - Normalized gradient convergence');
subplot(2,1,1);
for ni = 1:length(nu_bars)
    plot(t, results(ni).a0_NG, 'Color',colors{ni}, 'LineWidth', 1.3); hold on;
end
yline(a0_true,'k--','LineWidth',1.2);
grid on;
ylabel('$\hat{a}_0(t)$','Interpreter','latex');
title('Normalized gradient: $\hat{a}_0(t)$ for different noise levels','Interpreter','latex');
legend([labels, {'True $a_0$'}],'Interpreter','latex','Location','best');
ylim([-0.5 4.5]);

subplot(2,1,2);
for ni = 1:length(nu_bars)
    plot(t, results(ni).b0_NG, 'Color',colors{ni}, 'LineWidth', 1.3); hold on;
end
yline(b0_true,'k--','LineWidth',1.2);
grid on;
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$\hat{b}_0(t)$','Interpreter','latex');
ylim([-0.5 2.5]);

%% --- Figure 3: error norm comparison at highest noise ---
ni = length(nu_bars);
err_G  = sqrt((results(ni).a0_G  - a0_true).^2 + (results(ni).b0_G  - b0_true).^2);
err_NG = sqrt((results(ni).a0_NG - a0_true).^2 + (results(ni).b0_NG - b0_true).^2);

figure('Name','Ex10 Fig3 - Error norm comparison');
plot(t, err_G,  'b',  'LineWidth', 1.4); hold on;
plot(t, err_NG, 'r--','LineWidth', 1.4);
grid on;
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$\|\tilde{\theta}(t)\|$','Interpreter','latex');
title(sprintf('Parameter error norm ($\\bar{\\nu}=%.2f$)', nu_bars(end)),'Interpreter','latex');
legend('Gradient','Normalized gradient','Interpreter','latex','Location','best');

%% --- Figure 4: Lyapunov function V(t) ---
figure('Name','Ex10 Fig4 - Lyapunov');
Gamma_inv = (1/gamma)*eye(2);
th_G_err  = [results(end).a0_G  - a0_true, results(end).b0_G  - b0_true];
th_NG_err = [results(end).a0_NG - a0_true, results(end).b0_NG - b0_true];
V_G  = sum((th_G_err  * Gamma_inv) .* th_G_err,  2);
V_NG = sum((th_NG_err * Gamma_inv) .* th_NG_err, 2);
semilogy(t, V_G,  'b',  'LineWidth', 1.4); hold on;
semilogy(t, V_NG, 'r--','LineWidth', 1.4);
grid on;
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$V(\tilde{\theta})$','Interpreter','latex');
title('Lyapunov function $V = \|\tilde{\theta}\|^2/(2\gamma)$','Interpreter','latex');
legend('Gradient','Normalized gradient','Interpreter','latex','Location','best');
