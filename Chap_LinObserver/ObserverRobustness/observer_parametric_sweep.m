%% ========================================================================
%  OBSERVER TUNING: PARAMETRIC SWEEP ANALYSIS
%  ========================================================================
%  Trade-off surface analysis:
%  - Observer speed (speed ratio from 1 to 20)
%  - Measurement noise level (0 to 10 mV)
%  - Actuator saturation frequency
%
%  Goal: Find optimal operating region matching book guidelines
%% ========================================================================
clearvars; close all; clc; % 'clearvars' est préféré à 'clear all'

% --- Force le rendu LaTeX pour les graphiques ---
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

fprintf('\n%s\n', repmat('=',80,1));
fprintf('PARAMETRIC SWEEP: Observer Speed vs Noise vs Saturation\n');
fprintf('%s\n', repmat('=',80,1));

%% System setup (same as testbench)
m = 1.0;
b = 0.3;
k = 1.0;
A = [0, 1; -k/m, -b/m];
B = [0; 1/m];
C = [1, 0];
Ts = 0.01;
cl_poles = [-1, -2];
K = place(A, B, cl_poles);
u_max = 5.0;

%% Parametric sweep setup
speed_ratios = 1:1:15;  % 1 to 15 times faster than slowest CL pole
noise_levels_mV = 0:1:10;  % 0 to 10 mV sensor noise
noise_levels = noise_levels_mV * 1e-3;
sim_time = 10;
Ts_sweep = 0.01;
t_sweep = 0:Ts_sweep:sim_time;
N_sweep = length(t_sweep);

%% Data storage
metrics = struct();
metrics.noise_gain = zeros(length(speed_ratios), length(noise_levels));
metrics.est_error_pos = zeros(length(speed_ratios), length(noise_levels));
metrics.est_error_vel = zeros(length(speed_ratios), length(noise_levels));
metrics.saturation_freq = zeros(length(speed_ratios), length(noise_levels));
metrics.settling_time = zeros(length(speed_ratios), length(noise_levels));
metrics.control_effort = zeros(length(speed_ratios), length(noise_levels));
x_ref = [1.0; 0];

rng(42);  % Reproducible random noise

fprintf('\nStarting parametric sweep...\n');
fprintf('Speed ratios: %d values\n', length(speed_ratios));
fprintf('Noise levels: %d values\n', length(noise_levels));
fprintf('Total simulations: %d\n\n', length(speed_ratios) * length(noise_levels));

count = 0;
for i_ratio = 1:length(speed_ratios)
    ratio = speed_ratios(i_ratio);
    obs_poles = ratio * cl_poles;
    L = place(A', C', obs_poles)';
    
    % Check stability
    eig_obs = eig(A - L*C);
    if any(real(eig_obs) >= 0)
        fprintf('⚠️  Ratio %.1f: Unstable observer poles detected!\n', ratio);
        metrics.noise_gain(i_ratio, :) = inf;
        metrics.est_error_pos(i_ratio, :) = inf;
        metrics.est_error_vel(i_ratio, :) = inf;
        metrics.saturation_freq(i_ratio, :) = nan;
        metrics.settling_time(i_ratio, :) = inf;
        metrics.control_effort(i_ratio, :) = inf;
        continue;
    end
    
    % Compute noise gain
    [noise_gain, ~] = compute_noise_gain_fast(A, L, C);
    
    for i_noise = 1:length(noise_levels)
        count = count + 1;
        if mod(count, 10) == 0
            fprintf('Progress: %.1f%% (ratio=%.1f, noise=%.1f mV)\n', ...
                100*count/(length(speed_ratios)*length(noise_levels)), ratio, noise_levels_mV(i_noise));
        end
        
        noise_level = noise_levels(i_noise);
        
        % Run simulation
        x = zeros(2, 1);
        x_hat = x;
        
        errors_pos = zeros(N_sweep, 1);
        errors_vel = zeros(N_sweep, 1);
        saturations = zeros(N_sweep, 1);
        controls = zeros(N_sweep, 1);
        
        for k = 1:N_sweep
            % Noisy measurement
            y_true = C * x;
            y_noisy = y_true + noise_level * randn();
            
            % Control
            u_unrestricted = -K * (x_hat - x_ref);
            u_sat = max(min(u_unrestricted, u_max), -u_max);
            
            % Observer with anti-windup
            x_hat = x_hat + Ts_sweep * (A * x_hat + B * u_sat + L * (y_noisy - C * x_hat));
            
            % Plant dynamics
            x = x + Ts_sweep * (A * x + B * u_sat);
            
            % Log metrics
            e = x_hat - x;
            errors_pos(k) = e(1);
            errors_vel(k) = e(2);
            saturations(k) = abs(u_sat) >= (u_max - 0.01);
            controls(k) = u_sat;
        end
        
        % Compute metrics (using renamed compute_rms to avoid conflicts)
        metrics.noise_gain(i_ratio, i_noise) = noise_gain;
        metrics.est_error_pos(i_ratio, i_noise) = compute_rms(errors_pos);
        metrics.est_error_vel(i_ratio, i_noise) = compute_rms(errors_vel);
        metrics.saturation_freq(i_ratio, i_noise) = 100 * sum(saturations) / N_sweep;
        metrics.settling_time(i_ratio, i_noise) = estimate_settling_time(errors_pos, Ts_sweep, 0.1);
        metrics.control_effort(i_ratio, i_noise) = compute_rms(controls);
    end
end
fprintf('\nParametric sweep complete!\n');

%% Analysis and plots
figure('Name', 'Parametric Sweep Results', 'Color', 'w', 'Position', [100, 100, 1400, 900]);

% Plot 1: Noise gain vs speed ratio
subplot(2, 3, 1);
noise_gain_vec = metrics.noise_gain(:, 1);  % No sensor noise case
plot(speed_ratios, noise_gain_vec, 'b-', 'LineWidth', 2);
hold on;
yline(20, 'r--', 'LineWidth', 2, 'DisplayName', 'Acceptable threshold');
xlabel('Speed ratio (observer / CL pole)');
ylabel('Peak noise gain');
title('Observer Noise Amplification vs Speed');
grid on;
legend('Location', 'best');
xlim([speed_ratios(1), speed_ratios(end)]);
% Note : xregion nécessite MATLAB R2023a ou supérieur
try
    xregion(2, 3, 'FaceColor', 'green', 'FaceAlpha', 0.1, 'DisplayName', 'Conservative zone');
    xregion(5, 10, 'FaceColor', 'red', 'FaceAlpha', 0.1, 'DisplayName', 'Aggressive zone');
catch
    % Fallback pour les versions plus anciennes de MATLAB
end

% Plot 2: Estimation error (position) vs speed and noise
subplot(2, 3, 2);
contourf(noise_levels_mV, speed_ratios, metrics.est_error_pos, 20);
colorbar;
xlabel('Measurement noise (mV)');
ylabel('Speed ratio');
title('Position Error RMS (m)');
hold on;
plot([0, max(noise_levels_mV)], [2.5, 2.5], 'r-', 'LineWidth', 2);
text(2, 2.7, 'Recommended zone', 'Color', 'red', 'FontSize', 10);

% Plot 3: Saturation frequency vs speed and noise
subplot(2, 3, 3);
contourf(noise_levels_mV, speed_ratios, metrics.saturation_freq, 20);
colorbar;
xlabel('Measurement noise (mV)');
ylabel('Speed ratio');
title('Saturation Frequency (\%)');

% Plot 4: Control effort vs speed ratio (no noise)
subplot(2, 3, 4);
control_effort_vec = metrics.control_effort(:, 1);
plot(speed_ratios, control_effort_vec, 'g-', 'LineWidth', 2);
hold on;
yline(u_max, 'r--', 'LineWidth', 2, 'DisplayName', '$u_{\max}$');
xlabel('Speed ratio');
ylabel('Control effort RMS (N)');
title('Control Effort vs Observer Speed');
grid on;
legend('Location', 'best');
xlim([speed_ratios(1), speed_ratios(end)]);

% Plot 5: 2D trade-off surface (error vs noise gain)
subplot(2, 3, 5);
idx_low_noise = 1;  % No noise case
scatter(noise_gain_vec(1:end-1), metrics.est_error_pos(1:end-1, idx_low_noise), ...
    100, speed_ratios(1:end-1), 'filled');
colorbar;
xlabel('Noise gain (theoretical)');
ylabel('Estimation error RMS (m)');
title('Noise Gain vs Error Trade-off');
grid on;
hold on;
plot(noise_gain_vec(2:3), metrics.est_error_pos(2:3, idx_low_noise), 'g^', ...
    'MarkerSize', 12, 'LineWidth', 2, 'DisplayName', 'Recommended');
legend('Location', 'best');

% Plot 6: Decision matrix
subplot(2, 3, 6);
decision_matrix = zeros(length(speed_ratios), 1);
for i = 1:length(speed_ratios)
    noise_gain = metrics.noise_gain(i, 1);
    error_pos = metrics.est_error_pos(i, 1);
    saturation = metrics.saturation_freq(i, 1);
    % Score: lower is better (Normalize and combine)
    score = (noise_gain / 50) + (error_pos / 0.1) + (saturation / 100);
    decision_matrix(i) = score;
end
bar(speed_ratios, decision_matrix);
xlabel('Speed ratio');
ylabel('Combined score (lower better)');
title('Overall Recommendation');
grid on; hold on;

% Highlight optimal
[~, idx_optimal] = min(decision_matrix);
plot(speed_ratios(idx_optimal), decision_matrix(idx_optimal), 'r*', 'MarkerSize', 20, 'DisplayName', 'Optimal');
try
    xregion(2, 3, 'FaceColor', 'green', 'FaceAlpha', 0.1, 'DisplayName', 'Conservative');
    xregion(5, 10, 'FaceColor', 'red', 'FaceAlpha', 0.1, 'DisplayName', 'Aggressive');
catch
end
legend('Location', 'best');

%% Print recommendations
fprintf('\n%s\n', repmat('=',80,1));
fprintf('RECOMMENDATIONS FROM PARAMETRIC SWEEP\n');
fprintf('%s\n', repmat('=',80,1));

fprintf('\n1. CONSERVATIVE ZONE (Speed ratio 2-3):\n');
idx_cons = find(speed_ratios >= 2 & speed_ratios <= 3);
fprintf('   Avg noise gain: %.2f\n', mean(metrics.noise_gain(idx_cons, 1)));
fprintf('   Avg position error: %.6f m\n', mean(metrics.est_error_pos(idx_cons, 1)));
fprintf('   Avg saturation frequency: %.2f%%\n', mean(metrics.saturation_freq(idx_cons, 1)));
fprintf('   ✓ Verdict: RECOMMENDED for most applications\n');

fprintf('\n2. BALANCED ZONE (Speed ratio 5):\n');
idx_bal = find(speed_ratios == 5);
fprintf('   Avg noise gain: %.2f\n', mean(metrics.noise_gain(idx_bal, 1)));
fprintf('   Avg position error: %.6f m\n', mean(metrics.est_error_pos(idx_bal, 1)));
fprintf('   Avg saturation frequency: %.2f%%\n', mean(metrics.saturation_freq(idx_bal, 1)));
fprintf('   ⚠ Verdict: Use after successful simulation\n');

fprintf('\n3. AGGRESSIVE ZONE (Speed ratio 5-10):\n');
idx_agg = find(speed_ratios >= 5 & speed_ratios <= 10);
fprintf('   Avg noise gain: %.2f\n', mean(metrics.noise_gain(idx_agg, 1)));
fprintf('   Avg position error: %.6f m\n', mean(metrics.est_error_pos(idx_agg, 1)));
fprintf('   Avg saturation frequency: %.2f%%\n', mean(metrics.saturation_freq(idx_agg, 1)));
fprintf('   ✗ Verdict: HIGH RISK - careful validation required\n');

fprintf('\n%s\n', repmat('=',80,1));
fprintf('END OF PARAMETRIC SWEEP\n');
fprintf('%s\n', repmat('=',80,1));

%% Helper functions (Must be at the very end of the file)

function [noise_gain, freq_crit] = compute_noise_gain_fast(A, L, C)
    % Fast approximation of noise gain Using Bode analysis at high frequency
    w_high = 100;  % Frequency in rad/s
    s = 1j * w_high;
    % CORRECTION: Mldivide (\) must be used instead of mrdivide (/) for (Matrix \ Vector)
    G = (s * eye(size(A)) - (A - L*C)) \ L;
    
    % CORRECTION: Cannot multiply G(2x1) by C'(2x1). The state noise gain is norm(G).
    noise_gain = norm(G, 'fro'); 
    freq_crit = w_high;
end

function tau_settle = estimate_settling_time(error, Ts, threshold)
    error_norm = abs(error);
    % CORRECTION: Settling time is the LAST time the error is outside the threshold
    idx = find(error_norm >= threshold, 1, 'last');
    if isempty(idx)
        tau_settle = 0; % Never exceeded
    elseif idx == length(error)
        tau_settle = inf; % Did not settle
    else
        tau_settle = (idx + 1) * Ts;
    end
end

% CORRECTION: Renamed function to avoid conflict with MATLAB's built-in 'rms'
function rms_val = compute_rms(signal)
    rms_val = sqrt(mean(signal.^2));
end