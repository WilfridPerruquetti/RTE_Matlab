% =========================================================
% Ex.8 — Off-line ARX identification and model order selection
% True CT system: G(s) = 1 / (s^2 + 3s + 2) = 1/((s+1)(s+2))
% Sampling: Ts = 0.1s,  N = 500 PRBS samples
% =========================================================
clear; clc; close all;

%% --- True continuous-time system ---
G_ct = tf(1, [1 3 2]);    % poles: s=-1, s=-2

%% --- Sampling and data generation ---
Ts = 0.1;
N  = 500;
t  = (0:N-1)'*Ts;

% PRBS input (requires Sysid Toolbox)
try
    u = idinput(N, 'prbs', [0, 0.3], [-1, 1]);
catch
    % Fallback: pseudo-random from shift register (no toolbox needed)
    u = sign(sin(2*pi*(0.1*(1:N)' + 0.37*(1:N)'.^2/N)));
end
u = u(:);

% Simulate true system (ZOH discretization)
G_dt  = c2d(G_ct, Ts, 'zoh');
y_true = lsim(G_dt, u, t);
rng(42);
sigma = 0.05;
y = y_true + sigma*randn(N,1);

%% --- Figure 1: PRBS input and output ---
figure('Name','Ex8 Fig1 - Data');
subplot(2,1,1);
stairs(t, u, 'b', 'LineWidth', 1.0);
grid on;
ylabel('$u_k$','Interpreter','latex');
title('PRBS input','Interpreter','latex');

subplot(2,1,2);
plot(t, y_true,'b','LineWidth',1.4); hold on;
plot(t, y,'Color',[0.7 0.7 0.7],'LineWidth',0.8);
grid on;
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$y_k$','Interpreter','latex');
title('System output (true and noisy)','Interpreter','latex');
legend('True','Noisy','Interpreter','latex','Location','best');

%% --- Split: estimation / validation ---
N_est = 300;
u_est = u(1:N_est);     y_est = y(1:N_est);
u_val = u(N_est+1:end); y_val = y(N_est+1:end);
N_val = N - N_est;

%% --- Build ARX regression matrix ---
% Model: y_k + a1*y_{k-1} + a2*y_{k-2} = b1*u_{k-1} + b2*u_{k-2}
% phi_k = [-y_{k-1}, -y_{k-2}, u_{k-1}, u_{k-2}]
function [Phi, Y] = build_arx(y_in, u_in, na, nb, nk)
    N_in = length(y_in);
    n0   = max(na, nb+nk-1) + 1;
    Phi  = zeros(N_in - n0 + 1, na + nb);
    Y    = y_in(n0:end);
    for k = n0:N_in
        row = zeros(1, na+nb);
        for i = 1:na
            row(i) = -y_in(k-i);
        end
        for j = 1:nb
            row(na+j) = u_in(k-j-nk+1);
        end
        Phi(k-n0+1,:) = row;
    end
end

%% --- Least-squares estimation for each order ---
orders = 1:4;
SSE_est = zeros(size(orders));
SSE_val = zeros(size(orders));
R2_est  = zeros(size(orders));
n_params = zeros(size(orders));

fprintf('%-6s %-8s %-10s %-10s %-10s %-10s %-10s\n',...
    'Order','p','SSE_est','R2_est','SSE_val','AIC','BIC');

all_theta = cell(length(orders),1);

for idx = 1:length(orders)
    na = orders(idx); nb = orders(idx); nk = 1;
    p  = na + nb;
    n_params(idx) = p;

    % Build matrices on estimation data
    [Phi_e, Y_e] = build_arx(y_est, u_est, na, nb, nk);
    theta_hat    = Phi_e \ Y_e;
    all_theta{idx} = theta_hat;

    % Residuals on estimation data
    e_est      = Y_e - Phi_e*theta_hat;
    SSE_est(idx) = sum(e_est.^2);
    R2_est(idx)  = 1 - sum(e_est.^2)/sum((Y_e-mean(Y_e)).^2);

    % Residuals on validation data
    [Phi_v, Y_v] = build_arx(y_val, u_val, na, nb, nk);
    e_val       = Y_v - Phi_v*theta_hat;
    SSE_val(idx) = sum(e_val.^2);

    % Information criteria (on estimation data)
    Ne  = length(Y_e);
    AIC = Ne*log(SSE_est(idx)/Ne) + 2*p;
    BIC = Ne*log(SSE_est(idx)/Ne) + p*log(Ne);

    fprintf('%-6d %-8d %-10.4f %-10.5f %-10.4f %-10.2f %-10.2f\n',...
        na, p, SSE_est(idx), R2_est(idx), SSE_val(idx), AIC, BIC);
end

%% --- Figure 2: AIC/BIC vs order ---
Ne = N_est - max(orders) - 1;
AIC_vals = Ne*log(SSE_est/Ne) + 2*n_params;
BIC_vals = Ne*log(SSE_est/Ne) + n_params*log(Ne);

figure('Name','Ex8 Fig2 - AIC and BIC');
plot(orders, AIC_vals,'b-o','LineWidth',1.4,'MarkerSize',7); hold on;
plot(orders, BIC_vals,'r-s','LineWidth',1.4,'MarkerSize',7);
grid on;
xlabel('Model order $n_a = n_b$','Interpreter','latex');
ylabel('Information criterion','Interpreter','latex');
title('AIC and BIC vs.\ model order','Interpreter','latex');
legend('AIC','BIC','Interpreter','latex','Location','best');
[~,best_aic] = min(AIC_vals); [~,best_bic] = min(BIC_vals);
xline(orders(best_aic),'b--'); xline(orders(best_bic),'r--');

%% --- Selected model (order 2) ---
na = 2; nb = 2; nk = 1;
[Phi_e, Y_e] = build_arx(y_est, u_est, na, nb, nk);
theta_best   = Phi_e \ Y_e;
a1h = theta_best(1); a2h = theta_best(2);
b1h = theta_best(3); b2h = theta_best(4);
fprintf('\nSelected ARX(2,2,1): a=[%.4f %.4f], b=[%.4f %.4f]\n',...
    a1h, a2h, b1h, b2h);

%% --- Residual analysis on validation data ---
[Phi_v, Y_v] = build_arx(y_val, u_val, na, nb, nk);
e_val_best   = Y_v - Phi_v*theta_best;
conf_bound   = 1.96/sqrt(N_val);

figure('Name','Ex8 Fig3 - Residual analysis');
subplot(2,1,1);
[Ree, lags] = xcorr(e_val_best, 30, 'coeff');
stem(lags, Ree, 'filled', 'MarkerSize', 3); hold on;
yline( conf_bound,'r--'); yline(-conf_bound,'r--');
grid on;
xlabel('Lag $\ell$','Interpreter','latex');
ylabel('$\hat{R}_{ee}(\ell)$','Interpreter','latex');
title(['Residual autocorrelation (95\% bounds: $\pm$' ...
    sprintf('%.3f',conf_bound) ')'],'Interpreter','latex');

subplot(2,1,2);
[Reu, lags2] = xcorr(e_val_best, u_val(1:N_val), 30, 'coeff');
stem(lags2, Reu, 'filled', 'MarkerSize', 3); hold on;
yline( conf_bound,'r--'); yline(-conf_bound,'r--');
grid on;
xlabel('Lag $\ell$','Interpreter','latex');
ylabel('$\hat{R}_{eu}(\ell)$','Interpreter','latex');
title('Residual-input cross-correlation','Interpreter','latex');

%% --- Continuous-time pole recovery ---
A_dt_poly = [1, a1h, a2h];
z_poles   = roots(A_dt_poly);
s_poles   = log(z_poles) / Ts;
tau_ct    = -1./real(s_poles);
fprintf('\nDiscrete poles: z1=%.4f, z2=%.4f\n', z_poles(1), z_poles(2));
fprintf('CT poles: s1=%.4f, s2=%.4f\n', s_poles(1), s_poles(2));
fprintf('CT time constants: tau1=%.4f s, tau2=%.4f s\n', tau_ct(1), tau_ct(2));
