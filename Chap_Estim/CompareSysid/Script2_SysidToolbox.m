% =========================================================
% Script 2 - Identification with System Identification Toolbox
% True system: G(s) = 3/((1+0.4s)(1+1.2s)(1+2.5s))
% Ts=0.1 s, N=1500 (1000 est + 500 val)
% =========================================================
clear; clc; close all;

%% 1. True system
s_op = tf('s');
G_ct = 3/((1+0.4*s_op)*(1+1.2*s_op)*(1+2.5*s_op));
Ts   = 0.1;
G_dt = c2d(G_ct, Ts, 'zoh');
fprintf('True CT poles: s = -0.4, -0.833, -2.5\n');
fprintf('True time constants: tau = 0.4, 1.2, 2.5 s\n\n');

%% 2. PRBS experiment
N   = 1500; N_est = 1000; N_val = N - N_est;
rng(42);
u_prbs = idinput(N,'prbs',[0 0.25],[-1.5 1.5]);

y_true  = lsim(G_dt, u_prbs, (0:N-1)'*Ts);
sigma   = 0.02*std(y_true);
rng(99);
y_noisy = y_true + sigma*randn(N,1);
fprintf('SNR = %.1f dB\n\n', 20*log10(std(y_true)/sigma));

%% 3. Build iddata and split
z  = detrend(iddata(y_noisy, u_prbs, Ts));
ze = z(1:N_est);     % estimation subset
zv = z(N_est+1:end); % validation subset

%% 4. Delay estimation
d_est = delayest(ze);
fprintf('delayest: nk = %d sample(s)\n\n', d_est);

%% 5. Model estimation
na = 3; nb = 3; nk = max(1, d_est);

m_arx    = arx(ze, [na nb nk]);         % linear regression
m_oe     = oe(ze,  [nb na nk]);         % output-error
m_tf_dt  = tfest(ze, 3, 2);             % DT transfer function
m_tf_ct  = tfest(ze, 3, 2, 'Ts', 0);   % direct CT estimation
m_ss     = ssest(ze, 3);                % state-space

%% 6. Validation: compare and resid
figure;
compare(zv, m_arx, m_oe, m_tf_dt, m_ss);
legend('Validation','ARX','OE','TFEST','SSEST',...
'Interpreter','latex','Location','best');
title('Output comparison on validation data','Interpreter','latex');

figure;
resid(zv, m_arx, m_oe, m_tf_dt, m_ss);

%% 7. ARX order scanning
V      = arxstruc(ze, zv, struc(1:5, 1:5, 1:3));
orders = selstruc(V, 0);
m_best = arx(ze, orders);
fprintf('Selected orders [na nb nk] = [%d %d %d]\n\n', orders);

%% 8. Continuous-time recovery
m_arx_ct = d2c(tf(m_arx), 'zoh');
m_oe_ct  = d2c(tf(m_oe),  'zoh');

fprintf('ARX -> CT poles:  '); fprintf('%.4f  ', sort(real(pole(m_arx_ct)))); fprintf('\n');
fprintf('OE  -> CT poles:  '); fprintf('%.4f  ', sort(real(pole(m_oe_ct))));  fprintf('\n');
fprintf('CT TFEST poles:   '); fprintf('%.4f  ', sort(real(pole(m_tf_ct)))); fprintf('\n');
fprintf('True CT poles:    -2.5000  -0.8333  -0.4000\n\n');

tau_oe  = sort(-1./real(pole(m_oe_ct)(real(pole(m_oe_ct))<0)));
tau_tf  = sort(-1./real(pole(m_tf_ct)(real(pole(m_tf_ct))<0)));
fprintf('OE time constants:    '); fprintf('%.4f  ', tau_oe);  fprintf('s\n');
fprintf('TFEST time constants: '); fprintf('%.4f  ', tau_tf);  fprintf('s\n');
fprintf('True time constants:  0.4000  1.2000  2.5000 s\n\n');

%% 9. Bode comparison
figure;
bode(G_ct, {0.1,30}, 'b'); hold on;
bode(m_tf_ct, {0.1,30}, 'r--');
bode(m_oe_ct, {0.1,30}, 'g:'); grid on;
legend('True $G(s)$','CT TFEST','OE$\to$CT',...
'Interpreter','latex','Location','southwest');
title('Bode: true vs.\ identified (continuous time)','Interpreter','latex');

%% 10. PEM refinement of ARX
m_pem = pem(ze, m_arx);
[~, fit_pem] = compare(zv, m_pem);
fprintf('PEM refinement of ARX: validation fit = %.2f%%\n', fit_pem);