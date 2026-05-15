% =========================================================
% Script 1 - Off-line ARX identification without toolbox
% True system: G(s) = wn^2/(s^2 + 2*zeta*wn*s + wn^2)
% wn=3, zeta=0.4, Ts=0.1 s, N=1200 (900 est + 300 val)
% =========================================================
clear; clc; close all;

%% 1. True system
wn = 3.0; zeta = 0.4;
G_ct = tf(wn^2, [1, 2*zeta*wn, wn^2]);
Ts   = 0.1;
G_dt = c2d(G_ct, Ts, 'zoh');
[b_true, a_true] = tfdata(G_dt,'v');

%% 2. PRBS input and noisy output
N = 1200; N_est = 900; N_val = N - N_est;
rng(42);
k_idx = (0:N-1)';
u     = sign(sin(2*pi*(0.15*k_idx + 0.3*k_idx.^2/N)));  % PRBS-like
y_true = lsim(G_dt, u, k_idx*Ts);
sigma  = 0.02*std(y_true);
y      = y_true + sigma*randn(N,1);

%% 3. Model order selection (AIC and BIC on estimation data)
fprintf('%-6s  %-6s  %-10s  %-10s\n','na=nb','p','AIC','BIC');
for na = 1:4
n0 = na+1; Ne = N_est-n0+1;
Phi = zeros(Ne,2*na); Y_e = zeros(Ne,1);
for k = n0:N_est
Phi(k-n0+1,:) = [-y(k-1:-1:k-na)', u(k-1:-1:k-na)'];
Y_e(k-n0+1)   = y(k);
end
th    = Phi\Y_e;
e_est = Y_e - Phi*th;
SSE   = sum(e_est.^2);
AIC   = Ne*log(SSE/Ne) + 2*(2*na);
BIC   = Ne*log(SSE/Ne) + (2*na)*log(Ne);
fprintf('%-6d  %-6d  %-10.2f  %-10.2f\n',na,2*na,AIC,BIC);
end

%% 4. Final estimate: ARX(2,2,1) (selected by AIC/BIC)
na = 2; nb = 2; nk = 1; p = na+nb; n0 = na+1;
Ne = N_est-n0+1;
Phi_est = zeros(Ne,p); Y_est = zeros(Ne,1);
for k = n0:N_est
Phi_est(k-n0+1,:) = [-y(k-1:-1:k-na)', u(k-1:-1:k-nb)'];
Y_est(k-n0+1)     = y(k);
end
theta_hat = Phi_est\Y_est;
a_hat = [1; theta_hat(1:na)];
b_hat = [0; theta_hat(na+1:end)];

fprintf('\nTrue A: '); fprintf('%.6f  ',a_true); fprintf('\n');
fprintf('Est  A: '); fprintf('%.6f  ',a_hat'); fprintf('\n');
fprintf('True B: '); fprintf('%.6f  ',b_true); fprintf('\n');
fprintf('Est  B: '); fprintf('%.6f  ',b_hat'); fprintf('\n');

%% 5. Validation
G_hat  = tf(b_hat',a_hat',Ts);
y_hat  = lsim(G_hat,u,k_idx*Ts);
e_val  = y(N_est+1:end) - y_hat(N_est+1:end);
R2_val = 1 - sum(e_val.^2)/sum((y(N_est+1:end)-mean(y(N_est+1:end))).^2);
fprintf('\nR2 on validation = %.5f\n',R2_val);

conf = 1.96/sqrt(N_val); max_lag = 30;
[Ree,lags_ee] = xcorr(e_val,max_lag,'coeff');
[Reu,lags_eu] = xcorr(e_val,u(N_est+1:end),max_lag,'coeff');
fprintf('Autocorrelation  violations: %d / %d\n',...
sum(abs(Ree(lags_ee~=0))>conf), 2*max_lag);
fprintf('Cross-correlation violations: %d / %d\n',...
sum(abs(Reu)>conf), 2*max_lag+1);

%% 6. Continuous-time pole recovery
z_poles  = roots(a_hat);
s_poles  = log(z_poles)/Ts;
wn_hat   = abs(s_poles(1));
zeta_hat = -real(s_poles(1))/wn_hat;
fprintf('\nwn_hat = %.4f (true %.4f), zeta_hat = %.4f (true %.4f)\n',...
wn_hat,wn,zeta_hat,zeta);

%% 7. Figures
figure;
subplot(2,1,1); stairs(k_idx*Ts,u,'b','LineWidth',0.8);
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$u_k$','Interpreter','latex');
title('PRBS input','Interpreter','latex'); grid on;

subplot(2,1,2);
plot(k_idx*Ts,y_true,'b','LineWidth',1.4); hold on;
plot(k_idx*Ts,y,'Color',[0.7 0.7 0.7],'LineWidth',0.7);
xline(N_est*Ts,'k--','LineWidth',1.2); grid on;
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$y_k$','Interpreter','latex');
title('Output: true (blue), noisy (grey)','Interpreter','latex');
legend('True','Noisy','Est|Val','Interpreter','latex','Location','best');

set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureInputOutputEstim


figure;
t_val = ((N_est):(N-1))*Ts;
plot(t_val,y(N_est+1:end),'Color',[0.7 0.7 0.7],'LineWidth',0.8); hold on;
plot(t_val,y_hat(N_est+1:end),'b--','LineWidth',1.6); grid on;
xlabel('$t$ [s]','Interpreter','latex');
ylabel('$y_k$','Interpreter','latex');
title(sprintf('Validation: ARX model ($R^2=%.4f$)',R2_val),'Interpreter','latex');
legend('Noisy measurement','ARX model','Interpreter','latex','Location','best');

set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureARX


figure;
subplot(2,1,1);
stem(lags_ee,Ree,'filled','MarkerSize',3,'Color','b'); hold on;
yline(conf,'r--'); yline(-conf,'r--'); grid on;
xlabel('Lag $\ell$','Interpreter','latex');
ylabel('$\hat{R}_{ee}(\ell)$','Interpreter','latex');
title('Residual autocorrelation','Interpreter','latex');

subplot(2,1,2);
stem(lags_eu,Reu,'filled','MarkerSize',3,'Color','r'); hold on;
yline(conf,'r--'); yline(-conf,'r--'); grid on;
xlabel('Lag $\ell$','Interpreter','latex');
ylabel('$\hat{R}_{eu}(\ell)$','Interpreter','latex');
title('Residual-input cross-correlation','Interpreter','latex');

set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureResidualSysid


figure; bode(G_ct,'b'); hold on; bode(G_hat,'r--'); grid on;
legend('True $G(s)$','ARX model','Interpreter','latex','Location','best');
title('Bode comparison: true vs.\ ARX model','Interpreter','latex');
set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureBodeCompare
