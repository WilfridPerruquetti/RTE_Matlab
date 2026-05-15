% Motor parameters
tau = 0.1; k_p = 2.5;
A = [0 1; 0 -1/tau]; B = [0; k_p/tau]; C = [1 0];

% Observer design
poles_obs = [-30, -40];
L = place(A', C', poles_obs)';

% Controller design: stabilize at position setpoint
% Desired closed-loop poles: {-5, -6}
poles_ctrl = [-5, -6];
K = place(A, B, poles_ctrl);

% Simulation parameters
t = 0:0.001:1; % 1 second
x = [0; 0]; % Initial state: no motion
xhat = [2; 1]; % Initial estimate
u_cmd = 0.5; % Command voltage

% History storage
t_hist = t;
x_hist = zeros(2, length(t));
xhat_hist = zeros(2, length(t));
error_hist = zeros(2, length(t));

% Simulation loop
for k = 1:length(t)-1
% Measurement: only position
y = C * x;

% Observer update
xhat_dot = A*xhat + B*u_cmd + L*(y - C*xhat);
xhat = xhat + 0.001 * xhat_dot;

% Plant update
x_dot = A*x + B*u_cmd;
x = x + 0.001 * x_dot;

% Store history
x_hist(:,k) = x;
xhat_hist(:,k) = xhat;
error_hist(:,k) = x - xhat;
end

% Plotting
figure;
% Position and estimate
subplot(3,1,1);
plot(t_hist, x_hist(1,:), 'b-', 'LineWidth', 2); hold on;
plot(t_hist, xhat_hist(1,:), 'r--', 'LineWidth', 1.5);
ylabel('Position (rad)'); legend('True $x_1$', 'Estimate $\hat{x}_1$');
grid on;

% Velocity and estimate  
subplot(3,1,2);
plot(t_hist, x_hist(2,:), 'b-', 'LineWidth', 2); hold on;
plot(t_hist, xhat_hist(2,:), 'r--', 'LineWidth', 1.5);
ylabel('Velocity (rad/s)'); legend('True $x_2$', 'Estimate $\hat{x}_2$');
grid on;

% Estimation error
subplot(3,1,3);
semilogy(t_hist, abs(error_hist(1,:)), 'g-', 'LineWidth', 1.5); hold on;
semilogy(t_hist, abs(error_hist(2,:)), 'm-', 'LineWidth', 1.5);
ylabel('|error|'); xlabel('Time (s)');
legend('|$e_1$|', '|$e_2$|');
grid on;

set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureMCCFullReducedOrderObserver