% =========================================================
% Ex.7 — Bode plot identification
% True system: G(s) = 4 / ((1+2s)(1+0.5s)(1+0.1s))
% =========================================================
clear; clc; close all;

%% --- True system ---
G_true = tf(4, conv([2,1], conv([0.5,1],[0.1,1])));

%% --- Generate noisy frequency response data ---
omega = logspace(-2, 2, 200)';    % [rad/s], log-spaced
[mag_true, phase_true] = bode(G_true, omega);
mag_true   = squeeze(mag_true);
phase_true = squeeze(phase_true);

rng(42);
mag_dB_true   = 20*log10(mag_true);
mag_dB_noisy  = mag_dB_true   + 0.8*randn(size(mag_dB_true));
phase_noisy   = phase_true + 2.5*randn(size(phase_true));

%% --- Figure 1: Bode plot (noisy) ---
figure('Name','Ex7 Fig1 - Bode diagram');
subplot(2,1,1);
semilogx(omega, mag_dB_true,'b','LineWidth',1.6); hold on;
semilogx(omega, mag_dB_noisy,'Color',[0.7 0.7 0.7],'LineWidth',0.8);
% Mark break frequencies
xline(0.5,'r--','$1/\tau_1=0.5$','Interpreter','latex','LabelVerticalAlignment','bottom');
xline(2.0,'r--','$1/\tau_2=2$','Interpreter','latex','LabelVerticalAlignment','bottom');
xline(10, 'r--','$1/\tau_3=10$','Interpreter','latex','LabelVerticalAlignment','bottom');
yline(12,'k:','$|k|_{dB}=12$','Interpreter','latex');
grid on;
ylabel('Magnitude [dB]','Interpreter','latex');
title('Bode diagram: true (blue) and noisy (grey)','Interpreter','latex');
legend('True','Noisy','Interpreter','latex','Location','southwest');

subplot(2,1,2);
semilogx(omega, phase_true,'b','LineWidth',1.6); hold on;
semilogx(omega, phase_noisy,'Color',[0.7 0.7 0.7],'LineWidth',0.8);
grid on;
xlabel('$\omega$ [rad/s]','Interpreter','latex');
ylabel('Phase [deg]','Interpreter','latex');

%% --- Step 1: Graphical reading ---
k_graph   = 4.0;
tau1_graph = 1/0.5;    % = 2.0
tau2_graph = 1/2.0;    % = 0.5
tau3_graph = 1/10.0;   % = 0.1

G_graph = tf(k_graph, conv([tau1_graph,1], conv([tau2_graph,1],[tau3_graph,1])));
fprintf('Graphical estimate: G(s) = %.1f / ((1+%.1fs)(1+%.1fs)(1+%.1fs))\n',...
    k_graph, tau1_graph, tau2_graph, tau3_graph);

%% --- Verification at omega = 2 ---
H2 = freqresp(G_true, 2);
fprintf('\nAt omega=2: |G|=%.4f=%.1f dB, phase=%.1f deg\n',...
    abs(H2), 20*log10(abs(H2)), angle(H2)*180/pi);
H2g = freqresp(G_graph, 2);
fprintf('Graphical: |G_hat|=%.4f=%.1f dB, phase=%.1f deg\n',...
    abs(H2g), 20*log10(abs(H2g)), angle(H2g)*180/pi);

%% --- Step 2: Numerical refinement using tfest (Sysid Toolbox) ---
% Build iddata from frequency response
frd_data = idfrd(mag_dB_noisy .* exp(1j*phase_noisy*pi/180), omega, 0);

% Estimate 3-pole, 0-zero transfer function
np = 3; nz = 0;
opt = tfestOptions('Display','off');
G_tfest = tfest(frd_data, np, nz, opt);
fprintf('\ntfest result:\n');
disp(G_tfest);

[mag_fit, phase_fit] = bode(G_tfest, omega);
mag_fit   = 20*log10(squeeze(mag_fit));
phase_fit = squeeze(phase_fit);

%% --- Figure 2: comparison ---
figure('Name','Ex7 Fig2 - Graphical vs tfest');
subplot(2,1,1);
semilogx(omega, mag_dB_noisy,'Color',[0.7 0.7 0.7],'LineWidth',0.8); hold on;
[mg,pg] = bode(G_graph,omega);
semilogx(omega, 20*log10(squeeze(mg)),'b--','LineWidth',1.6);
semilogx(omega, mag_fit,'r-','LineWidth',1.6);
grid on;
ylabel('Magnitude [dB]','Interpreter','latex');
legend('Noisy data','Graphical','{\tt tfest}','Interpreter','latex','Location','southwest');
title('Bode magnitude: graphical vs.\ {\tt tfest}','Interpreter','latex');

subplot(2,1,2);
semilogx(omega, phase_noisy,'Color',[0.7 0.7 0.7],'LineWidth',0.8); hold on;
semilogx(omega, squeeze(pg),'b--','LineWidth',1.6);
semilogx(omega, phase_fit,'r-','LineWidth',1.6);
grid on;
xlabel('$\omega$ [rad/s]','Interpreter','latex');
ylabel('Phase [deg]','Interpreter','latex');

%% --- Residual power spectral density ---
[mg_true2,~] = bode(G_true,omega);
mag_true2 = 20*log10(squeeze(mg_true2));
Svv = (pi/(omega(end)-omega(1))) * sum((mag_dB_noisy - mag_fit).^2);
fprintf('Residual spectral power Svv = %.4f\n', Svv);
