    % =========================================================
% Ex.6 Part 2 — Overdamped second-order identification
% True system: G(s) = 1.5 / ((1+0.2s)(1+1.3s))
% yss = 1.5, tau1 = 0.2, tau2 = 1.3
% =========================================================
clear; clc; close all;

%% --- True system ---
tau1_true = 0.2;
tau2_true = 1.3;
k_true    = 1.5;

G_true = tf(k_true, conv([tau1_true, 1], [tau2_true, 1]));

%% --- Generate noisy step response ---
Ts = 0.01; T = 12; t = (0:Ts:T)'; N = length(t);
[y_true, ~] = step(G_true, t);
rng(42);
y = y_true + 0.015*randn(N,1);

%% --- Figure 1: measured response ---
figure('Name','Ex6 Overdamped - Fig1');
plot(t, y_true,'b','LineWidth',1.6); hold on;
plot(t, y,'Color',[0.7 0.7 0.7],'LineWidth',0.8);
grid on;
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$y(t)$','Interpreter','latex');
title('Overdamped step response (noisy)','Interpreter','latex');
legend('True $y(t)$','Noisy measurement','Interpreter','latex','Location','best');

%% --- Step 1: Steady-state gain ---
N_ss  = round(0.85*N);
y_ss  = mean(y(N_ss:end));
k_hat = y_ss;
fprintf('k_hat = %.4f  (true: %.4f)\n', k_hat, k_true);

%% --- Step 2: Crossing times at 25% and 75% ---
y25 = 0.25 * y_ss;
y75 = 0.75 * y_ss;
i25 = find(y >= y25, 1, 'first');
i75 = find(y >= y75, 1, 'first');
t25 = t(i25);
t75 = t(i75);
fprintf('t25 = %.4f s,  t75 = %.4f s\n', t25, t75);

%% --- Step 3: Apply P/Q formulas ---
r  = t25 / t75;
P  = -18.561*r + 0.573/(r - 0.207) + 4.164;
Q  = 14.280*r^3 - 9.389*r^2 + 0.254*r + 1.321;
tau2_hat = (t75 - t25) / (Q * (1 + 1/P));
tau1_hat = tau2_hat / P;
fprintf('\nr = %.4f,  P = %.4f,  Q = %.4f\n', r, P, Q);
fprintf('tau1_hat = %.4f (true %.4f),  tau2_hat = %.4f (true %.4f)\n', ...
    tau1_hat, tau1_true, tau2_hat, tau2_true);

%% --- Step 4: Reconstruct and validate ---
G_hat = tf(k_hat, conv([tau1_hat,1],[tau2_hat,1]));
[y_hat,~] = step(G_hat, t);

e    = y - y_hat;
R2   = 1 - sum(e.^2)/sum((y-mean(y)).^2);
RMSE = sqrt(mean(e.^2));
fprintf('\nGraphical fit: R2=%.5f, RMSE=%.5f\n', R2, RMSE);

%% --- Step 5: Nonlinear LS refinement ---
model_od = @(p,tv) p(1)*(1 - (p(2)*exp(-tv/p(2)) - p(3)*exp(-tv/p(3)))/(p(2)-p(3)));
cost_od  = @(p) sum((y - model_od(p,t)).^2);
p0       = [k_hat, tau1_hat, tau2_hat];
opts     = optimset('Display','off','TolFun',1e-10,'TolX',1e-10);
p_opt    = fminsearch(cost_od, p0, opts);
k_opt    = p_opt(1);
tau1_opt = min(p_opt(2),p_opt(3));
tau2_opt = max(p_opt(2),p_opt(3));
y_opt    = model_od([k_opt,tau1_opt,tau2_opt], t);
R2_opt   = 1 - sum((y-y_opt).^2)/sum((y-mean(y)).^2);
fprintf('Nonlinear LS:  k=%.4f, tau1=%.4f, tau2=%.4f, R2=%.5f\n', ...
    k_opt, tau1_opt, tau2_opt, R2_opt);

%% --- Figure 2: comparison ---
figure('Name','Ex6 Overdamped - Fig2');
plot(t,y,'Color',[0.7 0.7 0.7],'LineWidth',0.8); hold on;
plot(t,y_hat,'b--','LineWidth',1.6);
plot(t,y_opt,'r-','LineWidth',1.6);
xline(t25,'k:'); xline(t75,'k:');
grid on;
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$y(t)$','Interpreter','latex');
title('Overdamped identification: graphical vs.\ nonlinear LS','Interpreter','latex');
legend('Noisy data','Graphical $t_{25}/t_{75}$','Nonlinear LS', ...
       'Interpreter','latex','Location','best');

%% --- Sensitivity analysis: add noise to t25/t75 ---
fprintf('\nSensitivity: noise on t25/t75 (+/-10%%):\n');
for delta = [-0.10, 0, 0.10]
    t25p = t25*(1+delta); t75p = t75*(1+delta);
    rp = t25p/t75p;
    Pp = -18.561*rp + 0.573/(rp-0.207) + 4.164;
    Qp = 14.280*rp^3 - 9.389*rp^2 + 0.254*rp + 1.321;
    tau2p = (t75p-t25p)/(Qp*(1+1/Pp));
    tau1p = tau2p/Pp;
    fprintf('  delta=%+.0f%%: tau1=%.4f, tau2=%.4f\n', delta*100, tau1p, tau2p);
end
