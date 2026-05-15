%% System Identification Toolbox: residual analysis
clear; clc; close all;

%% 1. Data
Ts = 0.05;
t  = (0:400)'*Ts;
% Original output model : y(t) = 2 - 1.2*exp(-0.5*t) - 0.5*exp(-2*t) - 0.2*exp(-8*t)
y_clean = 2 - 1.2*exp(-0.5*t) - 0.5*exp(-2*t) - 0.2*exp(-8*t);
y = y_clean + 0.01*randn(size(y_clean));

%% 2. System Identification Toolbox (tfest)
% input = step
u = ones(size(y));
data = iddata(y, u, Ts);

% Transfert function estimation (3 poles, 3 zeros)
sys_ident = tfest(data, 3, 3);
y_ident = step(sys_ident, t);

n_params=7;

%% 3. Assume y_val is measured output and yhat_val is model output
y_val=y;
yhat_val=y_ident;
u_val=u;

e = y_val - yhat_val;
N = length(e);
p = n_params;              % number of estimated parameters

% Basic statistics
e_mean = mean(e);
SSE = sum(e.^2);
sigma2 = SSE/N;
RMSE = sqrt(mean(e.^2));

fprintf('Residual mean      = %.6f\n', e_mean);
fprintf('Residual variance  = %.6f\n', sigma2);
fprintf('RMSE               = %.6f\n', RMSE);

% Information criteria
AIC  = N*log(SSE/N) + 2*p;
AICc = AIC + (2*p*(p+1))/(N-p-1);
BIC  = N*log(SSE/N) + p*log(N);

fprintf('AIC  = %.4f\n', AIC);
fprintf('AICc = %.4f\n', AICc);
fprintf('BIC  = %.4f\n', BIC);

% Residual autocorrelation and residual-input cross-correlation
maxLag = 30;
[Ree,lags] = xcorr(e,maxLag,'coeff');
[Reu,lags2] = xcorr(e,u_val,maxLag,'coeff');
conf = 1.96/sqrt(N);

figure;
stem(lags,Ree,'filled'); hold on;
yline(conf,'r--'); yline(-conf,'r--');
grid on; xlabel('Lag','interpreter','latex'); ylabel('Autocorrelation','interpreter','latex');
title('Residual autocorrelation','interpreter','latex');
set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureResidual


figure;
stem(lags2,Reu,'filled'); hold on;
yline(conf,'r--'); yline(-conf,'r--');
grid on; xlabel('Lag','interpreter','latex'); ylabel('Cross-correlation','interpreter','latex');
title('Residual-input cross-correlation','interpreter','latex');
set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureResidualxcorr


%% 4. Residual analysis using sysid
figure;
resid(sys_ident,data)
set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureResidualSysid
