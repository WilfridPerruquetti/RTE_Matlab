% =========================================================
% Ex.6 Part 1 — Underdamped second-order identification
% True system: G(s) = 4 / (s^2 + 1.2s + 4)
% zeta = 0.3, wn = 2, k = 1  (unit step => yss=1)
% =========================================================
clear; clc; close all;

%% --- True system ---
zeta_true = 0.3;
wn_true   = 2.0;
k_true    = 1.0;

num_true = k_true * wn_true^2;
den_true = [1, 2*zeta_true*wn_true, wn_true^2];
G_true   = tf(num_true, den_true);

%% --- Generate noisy step response ---
Ts  = 0.01;
T   = 15;
t   = (0:Ts:T)';
N   = length(t);

[y_true, ~] = step(G_true, t);
rng(42);
sigma_noise = 0.02;
y = y_true + sigma_noise * randn(N, 1);

%% --- Figure 1: measured step response ---
figure('Name','Ex6 Fig1 - Measured step response');
plot(t, y_true, 'b', 'LineWidth', 1.6); hold on;
plot(t, y,      'Color',[0.7 0.7 0.7], 'LineWidth', 0.8);
grid on;
xlabel('$t$ [s]',               'Interpreter','latex');
ylabel('$y(t)$',                'Interpreter','latex');
title('Underdamped step response (noisy)', 'Interpreter','latex');
legend('True $y(t)$','Noisy measurement','Interpreter','latex','Location','best');

%% --- Step 1: Steady-state gain ---
N_ss   = round(0.85*N);
y_ss   = mean(y(N_ss:end));
k_hat  = y_ss;                     % u0 = 1
fprintf('Estimated DC gain:  k_hat  = %.4f  (true: %.4f)\n', k_hat, k_true);

%% --- Step 2: Locate peaks and valleys ---
[pks, locs_pk] = findpeaks(y, t, 'MinPeakProminence', 0.03);
[vls, locs_vl] = findpeaks(-y, t, 'MinPeakProminence', 0.03);
vls = -vls;

t1 = locs_pk(1);  y1 = pks(1);
t3 = locs_pk(2);  y3 = pks(2);

fprintf('First peak:   t1 = %.3f s,  y(t1) = %.4f\n', t1, y1);
fprintf('Second peak:  t3 = %.3f s,  y(t3) = %.4f\n', t3, y3);

%% --- Step 3: Estimate zeta ---
Mp           = (y1 - y_ss) / y_ss;
zeta_hat     = -log(Mp) / sqrt(pi^2 + log(Mp)^2);
fprintf('\nOvershoot ratio:  Mp    = %.4f\n', Mp);
fprintf('Estimated zeta:   zeta_hat = %.4f  (true: %.4f)\n', zeta_hat, zeta_true);

%% --- Step 4: Estimate wn ---
Tp           = t3 - t1;
wn_hat       = 2*pi / (Tp * sqrt(1 - zeta_hat^2));
fprintf('Pseudo-period:    Tp    = %.4f s\n', Tp);
fprintf('Estimated wn:     wn_hat   = %.4f  (true: %.4f)\n', wn_hat, wn_true);

%% --- Step 5: Identified transfer function ---
fprintf('\nIdentified G(s) = %.4f / (s^2 + %.4fs + %.4f)\n', ...
    k_hat*wn_hat^2, 2*zeta_hat*wn_hat, wn_hat^2);

%% --- Step 6: Reconstruct and validate ---
G_hat = tf(k_hat*wn_hat^2, [1, 2*zeta_hat*wn_hat, wn_hat^2]);
[y_hat, ~] = step(G_hat, t);

e    = y - y_hat;
SSE  = sum(e.^2);
RMSE = sqrt(mean(e.^2));
R2   = 1 - sum(e.^2) / sum((y - mean(y)).^2);
fprintf('\nFit indicators: SSE=%.4f, RMSE=%.4f, R2=%.5f\n', SSE, RMSE, R2);

figure('Name','Ex6 Fig2 - Graphical fit');
plot(t, y,     'Color',[0.7 0.7 0.7], 'LineWidth',0.8); hold on;
plot(t, y_hat, 'b--', 'LineWidth', 1.8);
xline(t1,'r:'); xline(t3,'r:');
grid on;
xlabel('$t$ [s]',    'Interpreter','latex');
ylabel('$y(t)$',     'Interpreter','latex');
title(sprintf('Graphical identification ($R^2=%.4f$)', R2), 'Interpreter','latex');
legend('Noisy data','$\hat{G}$ (graphical)','Peak times', ...
       'Interpreter','latex','Location','best');

%% --- Step 7: Nonlinear LS refinement (if R2 < 0.95) ---
if R2 < 0.95
    fprintf('\nR2 < 0.95: running nonlinear least-squares refinement...\n');
end

model_ud = @(p, t_vec) p(1)*p(3)^2 * ...
    (1 - exp(-p(2)*p(3)*t_vec).*(cos(p(3)*sqrt(1-p(2)^2)*t_vec) + ...
    p(2)/sqrt(1-p(2)^2)*sin(p(3)*sqrt(1-p(2)^2)*t_vec)));
cost     = @(p) sum((y - model_ud(p, t)).^2);
p0       = [k_hat, zeta_hat, wn_hat];
opts     = optimset('Display','off','TolFun',1e-10,'TolX',1e-10);
p_opt    = fminsearch(cost, p0, opts);

k_opt    = p_opt(1);
zeta_opt = p_opt(2);
wn_opt   = p_opt(3);
y_opt    = model_ud(p_opt, t);
R2_opt   = 1 - sum((y-y_opt).^2)/sum((y-mean(y)).^2);

fprintf('Nonlinear LS:  k=%.4f, zeta=%.4f, wn=%.4f, R2=%.5f\n', ...
    k_opt, zeta_opt, wn_opt, R2_opt);

figure('Name','Ex6 Fig3 - Nonlinear LS refinement');
plot(t, y,     'Color',[0.7 0.7 0.7], 'LineWidth',0.8); hold on;
plot(t, y_hat, 'b--', 'LineWidth', 1.6);
plot(t, y_opt, 'r-',  'LineWidth', 1.6);
grid on;
xlabel('$t$ [s]', 'Interpreter','latex');
ylabel('$y(t)$',  'Interpreter','latex');
title('Graphical vs.\ nonlinear LS identification', 'Interpreter','latex');
legend('Noisy data','Graphical ($R^2$='+string(round(R2,4))+')', ...
       'Nonlinear LS ($R^2$='+string(round(R2_opt,4))+')', ...
       'Interpreter','latex','Location','best');

%% --- Step 8: Residual inspection ---
figure('Name','Ex6 Fig4 - Residuals');
subplot(2,1,1);
plot(t, y - y_opt, 'b', 'LineWidth', 1.0);
grid on;
ylabel('$e_i = y_i - \hat{y}_i$', 'Interpreter','latex');
title('Residuals (nonlinear LS fit)', 'Interpreter','latex');

subplot(2,1,2);
[acf, lags] = xcorr(y - y_opt, 30, 'coeff');
stem(lags, acf, 'filled', 'MarkerSize', 3);
hold on;
conf = 1.96/sqrt(N); yline(conf,'r--'); yline(-conf,'r--');
grid on;
xlabel('Lag', 'Interpreter','latex');
ylabel('$\hat{R}_{ee}(\ell)$', 'Interpreter','latex');
title('Residual autocorrelation', 'Interpreter','latex');
