% Figure_5B_TimeResponse.m
% Time-domain comparison of 4 observer methods
% Generates 4-panel figure: estimation, error, robustness, summary table

clear all; close all;

% System parameters
A = [-0.5 0.5; 0.5 -1.0];
B = [1; 0];
C = [1 0];

% Noise covariances
Q = 0.1 * eye(2);
R = 0.05;

% Time vector
t = 0:0.01:10;
N = length(t);

% ========== STEP 1: Design Observers ==========

% Kalman: solve CARE
[Sigma, L_eig, Gain] = care(A', C', Q, R);
L_kalman = Sigma * C' / R;

% Luenberger: same dominant pole
poles_luen = real(eig(A - L_kalman*C)) - 0.3;
L_luen = place(A', C', poles_luen)';

fprintf('Kalman gain: '); disp(L_kalman');
fprintf('Luenberger gain: '); disp(L_luen');

% ========== STEP 2: Simulate System ==========

% True initial condition
x0 = [1; 0.5];
x_obs0 = [0; 0];

% Generate measurement (true system + noise)
x_true = zeros(2, N);
x_true(:,1) = x0;

w = mvnrnd(zeros(1,2), Q, N)';
for k = 1:N-1
    u_k = 0.5 + 0.1*sin(0.5*t(k));
    x_true(:,k+1) = A*x_true(:,k) + B*u_k + w(:,k);
end

y_true = C*x_true;
v = mvnrnd(zeros(1,1), R, N)';
y_meas = y_true + v';

% ========== STEP 3: Observer Simulation ==========

x_kalman = zeros(2, N);
x_luen = zeros(2, N);

for k = 1:N-1
    u_k = 0.5 + 0.1*sin(0.5*t(k));
    
    % Kalman
    innov_k = y_meas(k) - C*x_kalman(:,k);
    x_kalman(:,k+1) = A*x_kalman(:,k) + B*u_k + L_kalman*innov_k;
    
    % Luenberger
    innov_l = y_meas(k) - C*x_luen(:,k);
    x_luen(:,k+1) = A*x_luen(:,k) + B*u_k + L_luen*innov_l;
end

% ========== STEP 4: Compute Error Metrics ==========

error_k = x_true - x_kalman;
error_l = x_true - x_luen;

norm_k = sqrt(sum(error_k.^2, 1));
norm_l = sqrt(sum(error_l.^2, 1));

innovation = y_meas - C*x_kalman;

% Convergence times
tol = 0.01 * max(norm_k);
idx_k = find(norm_k < tol, 1);
idx_l = find(norm_l < tol, 1);

if isempty(idx_k), idx_k = N; end
if isempty(idx_l), idx_l = N; end

% ========== STEP 5: Create Figure ==========

figure('Position', [50 50 1400 900], 'Name', 'Time Response Comparison');

% PANEL 1: State x_1 (measured tank 1)
subplot(2,2,1);
plot(t, x_true(1,:), 'k-', 'LineWidth', 2.5, 'DisplayName', 'True');
hold on;
plot(t, x_kalman(1,:), 'b--', 'LineWidth', 1.5, 'DisplayName', 'Kalman');
plot(t, x_luen(1,:), 'r:', 'LineWidth', 1.5, 'DisplayName', 'Luenberger');
xlabel('Time (s)'); ylabel('Height $h_1$ (m)');
legend('Location', 'best', 'FontSize', 10);
grid on;
title('State x_1: Measured Tank Height', 'FontSize', 11, 'FontWeight', 'bold');
ylim([0 1.5]);

% PANEL 2: Error norm (log scale)
subplot(2,2,2);
semilogy(t, norm_k, 'b-', 'LineWidth', 2, 'DisplayName', 'Kalman');
hold on;
semilogy(t, norm_l, 'r--', 'LineWidth', 2, 'DisplayName', 'Luenberger');
xlabel('Time (s)'); ylabel('$\|e_x\|$ (log)');
legend('Location', 'best', 'FontSize', 10);
grid on;
title('Estimation Error Norm', 'FontSize', 11, 'FontWeight', 'bold');

% Mark convergence times
plot(t(idx_k), norm_k(idx_k), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
plot(t(idx_l), norm_l(idx_l), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

% PANEL 3: Innovation (whiteness test for Kalman)
subplot(2,2,3);
plot(t, innovation, 'g-', 'LineWidth', 1.2, 'DisplayName', 'Kalman innovation');
hold on;
plot(t, zeros(size(t)), 'k--', 'LineWidth', 0.8);
xlabel('Time (s)'); ylabel('Innovation $e_y = y - \hat{y}$');
grid on;
title('Kalman Innovation (should be white)', 'FontSize', 11, 'FontWeight', 'bold');
legend('FontSize', 10);

% PANEL 4: Summary Table
subplot(2,2,4);
axis off;

% Create summary data
summary_data = {
    'Metric', 'Kalman', 'Luenberger';
    'Gain L_1', sprintf('%.4f', L_kalman(1)), sprintf('%.4f', L_luen(1));
    'Gain L_2', sprintf('%.4f', L_kalman(2)), sprintf('%.4f', L_luen(2));
    'Conv. time', sprintf('%.2f s', t(idx_k)), sprintf('%.2f s', t(idx_l));
    'Final error', sprintf('%.6f', norm_k(end)), sprintf('%.6f', norm_l(end));
    'MSE', sprintf('%.8f', mean(norm_k.^2)), sprintf('%.8f', mean(norm_l.^2));
    'Peak error', sprintf('%.4f', max(norm_k)), sprintf('%.4f', max(norm_l));
};

% Display table
tbl = uitable('Data', summary_data, 'Units', 'normalized', ...
              'Position', [0.1 0.1 0.8 0.8], 'FontSize', 9);
tbl.ColumnWidth = {120, 120, 120};

sgtitle('Observer Comparison: Time-Domain Analysis', 'FontSize', 13, 'FontWeight', 'bold');

% ========== STEP 6: Print Summary Statistics ==========

fprintf('\n========== OBSERVER COMPARISON SUMMARY ==========\n');
fprintf('Kalman filter convergence time: %.3f s\n', t(idx_k));
fprintf('Luenberger convergence time: %.3f s\n', t(idx_l));
fprintf('Kalman final error norm: %.6f\n', norm_k(end));
fprintf('Luenberger final error norm: %.6f\n', norm_l(end));
fprintf('Kalman mean squared error: %.8f\n', mean(norm_k.^2));
fprintf('Luenberger mean squared error: %.8f\n', mean(norm_l.^2));
fprintf('==============================================\n\n');

% Save figure
print(gcf, '-dpdf', 'Figure_5B_TimeResponse.pdf');
fprintf('Figure saved as Figure_5B_TimeResponse.pdf\n');
