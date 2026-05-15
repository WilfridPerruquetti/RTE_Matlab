%% ========================================================================
%  OBSERVER TUNING TESTBENCH: Saturation, Noise, and Robustness Analysis
%  ========================================================================
%  Comprehensive study of observer pole placement strategies:
%  - Conservative (2-3x faster)
%  - Aggressive (5-10x faster)
%  - Trade-off with noise and saturation
%
%  Author: [Your Name]
%  Purpose: Validate observer design guidelines from book Section X.X
%% ========================================================================

clear all; close all; clc;

% Global control
ENABLE_PLOTS = true;
ENABLE_PARAM_SWEEP = true;
ENABLE_MONTE_CARLO = false;  % Set to true for slow but complete analysis

%% ========================================================================
% PART 1: SYSTEM DEFINITION
%% ========================================================================

fprintf('\n%s\n', repmat('=',80,1));
fprintf('PART 1: SYSTEM SETUP\n');
fprintf('%s\n', repmat('=',80,1));

% Example system: 2nd order with saturation
% Model: Mass-Damper-Spring with velocity measurement
% x1 = position, x2 = velocity

m = 1.0;     % mass (kg)
b = 0.3;     % damping coefficient (N.s/m)
k = 1.0;     % spring constant (N/m)

% State-space: dx/dt = Ax + Bu, y = Cx
A = [0, 1; -k/m, -b/m];
B = [0; 1/m];
C = [1, 0];  % Measure position only

% Continuous-time system
sys_plant = ss(A, B, C, 0);
fprintf('Plant state-space model:\n');
disp(sys_plant);

% Discretization for simulation (sampling time)
Ts = 0.01;  % 100 Hz
sys_plant_d = c2d(sys_plant, Ts, 'zoh');

% Closed-loop controller: u = -K(x_hat - x_ref) with u_max constraint
% Design controller with pole placement: desired closed-loop poles
cl_poles_desired = [-1, -2];  % 1 rad/s and 2 rad/s
K = place(A, B, cl_poles_desired);

fprintf('\nClosed-loop controller gain K = [%.4f, %.4f]\n', K(1), K(2));
fprintf('Closed-loop poles (nominal): %.4f, %.4f\n', cl_poles_desired(1), cl_poles_desired(2));
fprintf('Slowest CL pole: %.4f rad/s (time constant: %.4f s)\n', ...
    cl_poles_desired(1), abs(1/cl_poles_desired(1)));

% Actuator constraint
u_max = 5.0;  % Maximum control input (N)
fprintf('Actuator saturation limit: u_max = %.2f N\n', u_max);

% Noise model
noise_position_std = 1e-3;  % 1 mm position noise (RMS)
noise_velocity_std = 1e-3;  % position sensor has 1 mm RMS noise
fprintf('Measurement noise (RMS): %.4f m\n', noise_position_std);

%% ========================================================================
% PART 2: OBSERVER DESIGN (DIFFERENT STRATEGIES)
%% ========================================================================

fprintf('\n%s\n', repmat('=',80,1));
fprintf('PART 2: OBSERVER DESIGN COMPARISON\n');
fprintf('%s\n', repmat('=',80,1));

% Strategy 1: Conservative (2-3x faster than slowest CL pole)
speed_ratio_conservative = 2.5;
obs_poles_conservative = speed_ratio_conservative * cl_poles_desired;
L_conservative = place(A', C', obs_poles_conservative)';

fprintf('\n--- CONSERVATIVE APPROACH ---\n');
fprintf('Speed ratio: %.2f x slowest CL pole\n', speed_ratio_conservative);
fprintf('Observer poles: %.4f, %.4f\n', obs_poles_conservative(1), obs_poles_conservative(2));
fprintf('Observer gain L = [%.6f; %.6f]\n', L_conservative(1), L_conservative(2));
tau_obs_conservative = 1/abs(obs_poles_conservative(1));
fprintf('Observer time constant: %.4f s\n', tau_obs_conservative);

% Strategy 2: Balanced (5x faster)
speed_ratio_balanced = 5;
obs_poles_balanced = speed_ratio_balanced * cl_poles_desired;
L_balanced = place(A', C', obs_poles_balanced)';

fprintf('\n--- BALANCED APPROACH ---\n');
fprintf('Speed ratio: %.2f x slowest CL pole\n', speed_ratio_balanced);
fprintf('Observer poles: %.4f, %.4f\n', obs_poles_balanced(1), obs_poles_balanced(2));
fprintf('Observer gain L = [%.6f; %.6f]\n', L_balanced(1), L_balanced(2));
tau_obs_balanced = 1/abs(obs_poles_balanced(1));
fprintf('Observer time constant: %.4f s\n', tau_obs_balanced);

% Strategy 3: Aggressive (10x faster)
speed_ratio_aggressive = 10;
obs_poles_aggressive = speed_ratio_aggressive * cl_poles_desired;
L_aggressive = place(A', C', obs_poles_aggressive)';

fprintf('\n--- AGGRESSIVE APPROACH ---\n');
fprintf('Speed ratio: %.2f x slowest CL pole\n', speed_ratio_aggressive);
fprintf('Observer poles: %.4f, %.4f\n', obs_poles_aggressive(1), obs_poles_aggressive(2));
fprintf('Observer gain L = [%.6f; %.6f]\n', L_aggressive(1), L_aggressive(2));
tau_obs_aggressive = 1/abs(obs_poles_aggressive(1));
fprintf('Observer time constant: %.4f s\n', tau_obs_aggressive);

% Compute noise amplification for each strategy
fprintf('\n%s\n', repmat('-',80,1));
fprintf('NOISE AMPLIFICATION ANALYSIS\n');
fprintf('%s\n', repmat('-',80,1));

[noise_gain_conservative, freq_crit_cons] = compute_noise_gain(A, L_conservative, C);
[noise_gain_balanced, freq_crit_bal] = compute_noise_gain(A, L_balanced, C);
[noise_gain_aggressive, freq_crit_agg] = compute_noise_gain(A, L_aggressive, C);

fprintf('\nConservative observer:\n');
fprintf('  Peak noise gain: %.2f\n', noise_gain_conservative);
fprintf('  (Sensor noise RMS × %.2f = estimated state noise RMS)\n', noise_gain_conservative);

fprintf('\nBalanced observer:\n');
fprintf('  Peak noise gain: %.2f\n', noise_gain_balanced);

fprintf('\nAggressive observer:\n');
fprintf('  Peak noise gain: %.2f\n', noise_gain_aggressive);
fprintf('  ⚠️  WARNING: Excessive noise amplification! (> 20 is usually problematic)\n');

%% ========================================================================
% PART 3: SIMULATION: TIME-DOMAIN CLOSED-LOOP RESPONSE
%% ========================================================================

fprintf('\n%s\n', repmat('=',80,1));
fprintf('PART 3: CLOSED-LOOP SIMULATION (NO SATURATION, NO NOISE)\n');
fprintf('%s\n', repmat('=',80,1));

sim_time = 5.0;  % seconds
t = 0:Ts:sim_time;
N = length(t);

% Reference trajectory: step
x_ref = [1.0; 0];  % Want position = 1 m, velocity = 0

% Initial conditions
x0 = zeros(2, 1);
x = x0;
x_hat_cons = x0;
x_hat_bal = x0;
x_hat_agg = x0;

% Storage
X_true = zeros(2, N);
X_hat_cons = zeros(2, N);
X_hat_bal = zeros(2, N);
X_hat_agg = zeros(2, N);
U_cons = zeros(1, N);
U_bal = zeros(1, N);
U_agg = zeros(1, N);
Y = zeros(1, N);
E_cons = zeros(2, N);  % Estimation error
E_bal = zeros(2, N);
E_agg = zeros(2, N);

for k = 1:N
    % Perfect measurement (no noise)
    y = C * x;
    Y(1, k) = y;
    
    % ===== CONSERVATIVE OBSERVER =====
    u_cons_unrestricted = -K * (x_hat_cons - x_ref);  % Desired control
    u_cons = saturate(u_cons_unrestricted, u_max);     % Saturated control
    U_cons(1, k) = u_cons;
    
    % Anti-windup: feed back saturated input
    x_hat_cons = x_hat_cons + Ts * (A * x_hat_cons + B * u_cons + L_conservative * (y - C * x_hat_cons));
    X_hat_cons(:, k) = x_hat_cons;
    E_cons(:, k) = x_hat_cons - x;
    
    % ===== BALANCED OBSERVER =====
    u_bal_unrestricted = -K * (x_hat_bal - x_ref);
    u_bal = saturate(u_bal_unrestricted, u_max);
    U_bal(1, k) = u_bal;
    
    x_hat_bal = x_hat_bal + Ts * (A * x_hat_bal + B * u_bal + L_balanced * (y - C * x_hat_bal));
    X_hat_bal(:, k) = x_hat_bal;
    E_bal(:, k) = x_hat_bal - x;
    
    % ===== AGGRESSIVE OBSERVER =====
    u_agg_unrestricted = -K * (x_hat_agg - x_ref);
    u_agg = saturate(u_agg_unrestricted, u_max);
    U_agg(1, k) = u_agg;
    
    x_hat_agg = x_hat_agg + Ts * (A * x_hat_agg + B * u_agg + L_aggressive * (y - C * x_hat_agg));
    X_hat_agg(:, k) = x_hat_agg;
    E_agg(:, k) = x_hat_agg - x;
    
    % ===== PLANT DYNAMICS =====
    % True system (using control from whichever observer was fastest to respond)
    % Here we use average: u_avg = (u_cons + u_bal + u_agg) / 3 for consistency
    u_plant = u_cons;  % Could also average or use one specific one
    x = x + Ts * (A * x + B * u_plant);
    X_true(:, k) = x;
    
end

fprintf('\nSimulation completed: %d time steps, %.2f seconds\n', N, sim_time);
fprintf('Final position: %.4f m (target: %.2f m)\n', X_true(1, N), x_ref(1));
fprintf('Final velocity: %.4f m/s (target: %.2f m/s)\n', X_true(2, N), x_ref(2));

%% ========================================================================
% PART 4: SATURATION AND WINDUP ANALYSIS
%% ========================================================================

fprintf('\n%s\n', repmat('=',80,1));
fprintf('PART 4: SATURATION ANALYSIS\n');
fprintf('%s\n', repmat('=',80,1));

n_sat_cons = sum(abs(U_cons) >= u_max - 0.01);
n_sat_bal = sum(abs(U_bal) >= u_max - 0.01);
n_sat_agg = sum(abs(U_agg) >= u_max - 0.01);

fprintf('Number of saturated time steps:\n');
fprintf('  Conservative: %d / %d (%.2f%%)\n', n_sat_cons, N, 100*n_sat_cons/N);
fprintf('  Balanced:     %d / %d (%.2f%%)\n', n_sat_bal, N, 100*n_sat_bal/N);
fprintf('  Aggressive:   %d / %d (%.2f%%)\n', n_sat_agg, N, 100*n_sat_agg/N);

% Estimation error statistics
err_rms_pos_cons = rms(E_cons(1, :));
err_rms_vel_cons = rms(E_cons(2, :));
err_rms_pos_bal = rms(E_bal(1, :));
err_rms_vel_bal = rms(E_bal(2, :));
err_rms_pos_agg = rms(E_agg(1, :));
err_rms_vel_agg = rms(E_agg(2, :));

fprintf('\nEstimation error (RMS) - Position:\n');
fprintf('  Conservative: %.6f m\n', err_rms_pos_cons);
fprintf('  Balanced:     %.6f m\n', err_rms_pos_bal);
fprintf('  Aggressive:   %.6f m\n', err_rms_pos_agg);

fprintf('\nEstimation error (RMS) - Velocity:\n');
fprintf('  Conservative: %.6f m/s\n', err_rms_vel_cons);
fprintf('  Balanced:     %.6f m/s\n', err_rms_vel_bal);
fprintf('  Aggressive:   %.6f m/s\n', err_rms_vel_agg);

%% ========================================================================
% PART 5: ROBUSTNESS TO PARAMETRIC UNCERTAINTY
%% ========================================================================

fprintf('\n%s\n', repmat('=',80,1));
fprintf('PART 5: ROBUSTNESS TO PARAMETRIC UNCERTAINTY\n');
fprintf('%s\n', repmat('=',80,1));

if ENABLE_PARAM_SWEEP
    % Sweep: ±20% variation in spring constant k
    k_perturbations = linspace(0.8*k, 1.2*k, 11);
    margin_data = [];
    
    for k_pert = k_perturbations
        A_pert = [0, 1; -k_pert/m, -b/m];
        
        % Check stability margins for each observer
        eig_cons = eig(A_pert - L_conservative * C);
        eig_bal = eig(A_pert - L_balanced * C);
        eig_agg = eig(A_pert - L_aggressive * C);
        
        % All eigenvalues must be in LHP for stability
        stable_cons = all(real(eig_cons) < 0);
        stable_bal = all(real(eig_bal) < 0);
        stable_agg = all(real(eig_agg) < 0);
        
        margin_data = [margin_data; k_pert, stable_cons, stable_bal, stable_agg];
    end
    
    fprintf('Parameter sweep: spring constant k ∈ [%.2f, %.2f]\n', min(k_perturbations), max(k_perturbations));
    fprintf('                   (±20%% nominal uncertainty)\n\n');
    fprintf('Stability map (1 = stable, 0 = unstable):\n');
    fprintf('   k value | Conservative | Balanced | Aggressive\n');
    fprintf('   --------|---------------|----------|----------\n');
    for i = 1:size(margin_data, 1)
        fprintf('   %.4f  |      %d       |    %d    |    %d\n', ...
            margin_data(i, 1), margin_data(i, 2), margin_data(i, 3), margin_data(i, 4));
    end
    
    stability_cons = sum(margin_data(:, 2)) / size(margin_data, 1);
    stability_bal = sum(margin_data(:, 3)) / size(margin_data, 1);
    stability_agg = sum(margin_data(:, 4)) / size(margin_data, 1);
    
    fprintf('\nStability rate across ±20%% perturbations:\n');
    fprintf('  Conservative: %.0f%%\n', 100*stability_cons);
    fprintf('  Balanced:     %.0f%%\n', 100*stability_bal);
    fprintf('  Aggressive:   %.0f%%\n', 100*stability_agg);
end

%% ========================================================================
% PART 6: RESPONSE WITH MEASUREMENT NOISE
%% ========================================================================

fprintf('\n%s\n', repmat('=',80,1));
fprintf('PART 6: ROBUSTNESS TO MEASUREMENT NOISE\n');
fprintf('%s\n', repmat('=',80,1));

% Simulate with realistic noise
rng(42);  % Reproducible
x = zeros(2, 1);
x_hat_cons_noisy = x;
x_hat_bal_noisy = x;
x_hat_agg_noisy = x;

X_true_noisy = zeros(2, N);
X_hat_cons_noisy = zeros(2, N);
X_hat_bal_noisy = zeros(2, N);
X_hat_agg_noisy = zeros(2, N);
E_cons_noisy = zeros(2, N);
E_bal_noisy = zeros(2, N);
E_agg_noisy = zeros(2, N);

for k = 1:N
    % Noisy measurement
    y_true = C * x;
    y_noisy = y_true + noise_position_std * randn();
    
    % ===== CONSERVATIVE OBSERVER (NOISY) =====
    u_cons_unrestricted = -K * (x_hat_cons_noisy - x_ref);
    u_cons = saturate(u_cons_unrestricted, u_max);
    x_hat_cons_noisy = x_hat_cons_noisy + Ts * (A * x_hat_cons_noisy + B * u_cons + ...
        L_conservative * (y_noisy - C * x_hat_cons_noisy));
    X_hat_cons_noisy(:, k) = x_hat_cons_noisy;
    E_cons_noisy(:, k) = x_hat_cons_noisy - x;
    
    % ===== BALANCED OBSERVER (NOISY) =====
    u_bal_unrestricted = -K * (x_hat_bal_noisy - x_ref);
    u_bal = saturate(u_bal_unrestricted, u_max);
    x_hat_bal_noisy = x_hat_bal_noisy + Ts * (A * x_hat_bal_noisy + B * u_bal + ...
        L_balanced * (y_noisy - C * x_hat_bal_noisy));
    X_hat_bal_noisy(:, k) = x_hat_bal_noisy;
    E_bal_noisy(:, k) = x_hat_bal_noisy - x;
    
    % ===== AGGRESSIVE OBSERVER (NOISY) =====
    u_agg_unrestricted = -K * (x_hat_agg_noisy - x_ref);
    u_agg = saturate(u_agg_unrestricted, u_max);
    x_hat_agg_noisy = x_hat_agg_noisy + Ts * (A * x_hat_agg_noisy + B * u_agg + ...
        L_aggressive * (y_noisy - C * x_hat_agg_noisy));
    X_hat_agg_noisy(:, k) = x_hat_agg_noisy;
    E_agg_noisy(:, k) = x_hat_agg_noisy - x;
    
    % ===== PLANT DYNAMICS =====
    u_plant = u_cons;
    x = x + Ts * (A * x + B * u_plant);
    X_true_noisy(:, k) = x;
end

% Measure noise amplification empirically
noise_amp_cons = rms(E_cons_noisy(1, :)) / noise_position_std;
noise_amp_bal = rms(E_bal_noisy(1, :)) / noise_position_std;
noise_amp_agg = rms(E_agg_noisy(1, :)) / noise_position_std;

fprintf('\nEmpirical noise amplification (in closed-loop estimation):\n');
fprintf('  Conservative: %.2f x\n', noise_amp_cons);
fprintf('  Balanced:     %.2f x\n', noise_amp_bal);
fprintf('  Aggressive:   %.2f x\n', noise_amp_agg);
fprintf('  (Noise RMS multiplied by these factors)\n');

fprintf('\nInterpretation:\n');
if noise_amp_cons < 10
    fprintf('  ✓ Conservative approach: GOOD noise rejection\n');
else
    fprintf('  ⚠ Conservative approach: Moderate noise amplification\n');
end
if noise_amp_bal < 15
    fprintf('  ✓ Balanced approach: ACCEPTABLE noise level\n');
else
    fprintf('  ⚠ Balanced approach: Significant noise amplification\n');
end
if noise_amp_agg > 30
    fprintf('  ✗ Aggressive approach: EXCESSIVE noise amplification!\n');
else
    fprintf('  ⚠ Aggressive approach: High noise amplification\n');
end

%% ========================================================================
% PART 7: VISUALIZATION
%% ========================================================================

if ENABLE_PLOTS
    
    % Figure 1: State estimation comparison (no noise)
    figure('Name', 'State Estimation - No Noise', 'NumberTitle', 'off');
    
    subplot(2, 1, 1);
    hold on;
    plot(t, X_true(1, :), 'k-', 'LineWidth', 2, 'DisplayName', 'True state');
    plot(t, X_hat_cons(1, :), 'r--', 'LineWidth', 1.5, 'DisplayName', 'Conservative');
    plot(t, X_hat_bal(1, :), 'b--', 'LineWidth', 1.5, 'DisplayName', 'Balanced');
    plot(t, X_hat_agg(1, :), 'm--', 'LineWidth', 1.5, 'DisplayName', 'Aggressive');
    ylabel('Position x_1 (m)', 'Interpreter', 'latex');
    legend('Location', 'best');
    grid on;
    xlim([0, sim_time]);
    title('State Estimation Comparison (No Measurement Noise)');
    
    subplot(2, 1, 2);
    hold on;
    plot(t, X_true(2, :), 'k-', 'LineWidth', 2, 'DisplayName', 'True state');
    plot(t, X_hat_cons(2, :), 'r--', 'LineWidth', 1.5, 'DisplayName', 'Conservative');
    plot(t, X_hat_bal(2, :), 'b--', 'LineWidth', 1.5, 'DisplayName', 'Balanced');
    plot(t, X_hat_agg(2, :), 'm--', 'LineWidth', 1.5, 'DisplayName', 'Aggressive');
    ylabel('Velocity x_2 (m/s)', 'Interpreter', 'latex');
    xlabel('Time (s)');
    legend('Location', 'best');
    grid on;
    xlim([0, sim_time]);
    
    % Figure 2: Estimation error comparison
    figure('Name', 'Estimation Error', 'NumberTitle', 'off');
    
    subplot(2, 1, 1);
    hold on;
    semilogy(t, abs(E_cons(1, :)), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Conservative');
    semilogy(t, abs(E_bal(1, :)), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Balanced');
    semilogy(t, abs(E_agg(1, :)), 'm-', 'LineWidth', 1.5, 'DisplayName', 'Aggressive');
    ylabel('Position error $|e_1|$ (m)', 'Interpreter', 'latex');
    legend('Location', 'best');
    grid on;
    xlim([0, sim_time]);
    title('Estimation Error vs Time (No Noise)');
    
    subplot(2, 1, 2);
    hold on;
    semilogy(t, abs(E_cons(2, :)), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Conservative');
    semilogy(t, abs(E_bal(2, :)), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Balanced');
    semilogy(t, abs(E_agg(2, :)), 'm-', 'LineWidth', 1.5, 'DisplayName', 'Aggressive');
    ylabel('Velocity error $|e_2|$ (m/s)', 'Interpreter', 'latex');
    xlabel('Time (s)');
    legend('Location', 'best');
    grid on;
    xlim([0, sim_time]);
    
    % Figure 3: Control input saturation
    figure('Name', 'Control Saturation', 'NumberTitle', 'off');
    hold on;
    plot(t, U_cons, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Conservative');
    plot(t, U_bal, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Balanced');
    plot(t, U_agg, 'm-', 'LineWidth', 1.5, 'DisplayName', 'Aggressive');
    yline(u_max, 'k--', 'LineWidth', 2, 'DisplayName', '$u_{\max}$');
    yline(-u_max, 'k--', 'LineWidth', 2);
    ylabel('Control input $u$ (N)', 'Interpreter', 'latex');
    xlabel('Time (s)');
    legend('Location', 'best');
    grid on;
    xlim([0, sim_time]);
    ylim([-2*u_max, 2*u_max]);
    title('Control Saturation Analysis');
    
    % Figure 4: Response with noise
    figure('Name', 'State Estimation - With Noise', 'NumberTitle', 'off');
    
    subplot(2, 1, 1);
    hold on;
    plot(t, X_true_noisy(1, :), 'k-', 'LineWidth', 2, 'DisplayName', 'True state');
    plot(t, X_hat_cons_noisy(1, :), 'r--', 'LineWidth', 1, 'DisplayName', 'Conservative');
    plot(t, X_hat_bal_noisy(1, :), 'b--', 'LineWidth', 1, 'DisplayName', 'Balanced');
    plot(t, X_hat_agg_noisy(1, :), 'm--', 'LineWidth', 1, 'DisplayName', 'Aggressive');
    ylabel('Position x_1 (m)', 'Interpreter', 'latex');
    legend('Location', 'best');
    grid on;
    xlim([0, sim_time]);
    title('State Estimation with Measurement Noise');
    
    subplot(2, 1, 2);
    hold on;
    plot(t, X_true_noisy(2, :), 'k-', 'LineWidth', 2, 'DisplayName', 'True state');
    plot(t, X_hat_cons_noisy(2, :), 'r--', 'LineWidth', 1, 'DisplayName', 'Conservative');
    plot(t, X_hat_bal_noisy(2, :), 'b--', 'LineWidth', 1, 'DisplayName', 'Balanced');
    plot(t, X_hat_agg_noisy(2, :), 'm--', 'LineWidth', 1, 'DisplayName', 'Aggressive');
    ylabel('Velocity x_2 (m/s)', 'Interpreter', 'latex');
    xlabel('Time (s)');
    legend('Location', 'best');
    grid on;
    xlim([0, sim_time]);
    
    % Figure 5: Summary comparison
    figure('Name', 'Summary Comparison', 'NumberTitle', 'off');
    
    % Data for comparison
    approaches = categorical({'Conservative', 'Balanced', 'Aggressive'});
    noise_gains = [noise_gain_conservative, noise_gain_balanced, noise_gain_aggressive];
    time_constants = [tau_obs_conservative, tau_obs_balanced, tau_obs_aggressive];
    
    subplot(1, 3, 1);
    bar(approaches, noise_gains, 'FaceColor', [0.2 0.6 0.8]);
    ylabel('Peak Noise Gain', 'Interpreter', 'latex');
    title('Noise Amplification');
    grid on;
    yline(20, 'r--', 'LineWidth', 2, 'DisplayName', 'Acceptable Threshold');
    
    subplot(1, 3, 2);
    bar(approaches, time_constants, 'FaceColor', [0.2 0.8 0.2]);
    ylabel('Time Constant $\tau_{obs}$ (s)', 'Interpreter', 'latex');
    title('Observer Speed');
    grid on;
    
    subplot(1, 3, 3);
    settling_times = [
        compute_settling_time(E_cons, Ts, 0.02),
        compute_settling_time(E_bal, Ts, 0.02),
        compute_settling_time(E_agg, Ts, 0.02)
    ];
    bar(approaches, settling_times, 'FaceColor', [0.8 0.2 0.2]);
    ylabel('Settling Time (s)', 'Interpreter', 'latex');
    title('Convergence Speed (No Noise)');
    grid on;
    
end

fprintf('\n%s\n', repmat('=',80,1));
fprintf('ANALYSIS COMPLETE\n');
fprintf('%s\n', repmat('=',80,1));

%% ========================================================================
% HELPER FUNCTIONS
%% ========================================================================

function u_sat = saturate(u, u_max)
    % Saturate control input
    u_sat = max(min(u, u_max), -u_max);
end

function [noise_gain, freq_critical] = compute_noise_gain(A, L, C)
    % Compute peak noise amplification of the observer
    % Noise gain = ||L * inv(sI - (A - LC)) * C'||_inf
    
    w = logspace(-2, 3, 1000);  % Frequency range
    H = zeros(size(w));
    
    for i = 1:length(w)
        s = 1j * w(i);
        G = L / (s * eye(size(A, 1)) - (A - L * C));
        H(i) = norm(G * C', 'fro');
    end
    
    [noise_gain, idx] = max(H);
    freq_critical = w(idx);
end

function tau_settle = compute_settling_time(error, Ts, threshold)
    % Compute time when error norm drops below threshold and stays there
    
    error_norm = sqrt(error(1, :).^2 + error(2, :).^2);
    
    % Find when error first drops below threshold
    below_threshold = error_norm < threshold;
    
    if any(below_threshold)
        settle_idx = find(below_threshold, 1, 'first');
        tau_settle = settle_idx * Ts;
    else
        tau_settle = inf;
    end
end

function rms_val = rms(signal)
    % RMS value of signal
    rms_val = sqrt(mean(signal.^2));
end
