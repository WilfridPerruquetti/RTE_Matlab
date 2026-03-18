% MATLAB code to compute the Euler approximation of the ODE
% dy/dt + 2*y = 1 - 2*t^2 with initial condition y(0) = 0

% Set up parameters
t0 = 0;  % Initial time
y0 = 0;  % Initial condition
tf = 1;  % Final time

% Number of steps
n_steps = 7; % Change this to 4, 5, 6, or 7 to see different results

% Calculate step size
h = (tf - t0) / n_steps;

% Initialize arrays to store time and solution values
t = linspace(t0, tf, n_steps + 1); % Time points
y = zeros(1, n_steps + 1); % Array to store approximate solutions

% Set initial condition
y(1) = y0;

% Define the function for the ODE dy/dt = 1 - 2*t^2 - 2*y
f = @(t, y) 1 - 2 * t^2 - 2 * y;

% Euler method loop
for i = 1:n_steps
    y(i + 1) = y(i) + h * f(t(i), y(i));
end

% Display the results
disp('Time points:')
disp(t)
disp('Euler approximate values:')
disp(y)

% Plotting the approximate solution
figure;
plot(t, y, 'ro-', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
hold on;

% Plotting the exact solution for comparison
t_exact = linspace(t0, tf, 100);
y_exact = t_exact.*(1-t_exact);
plot(t_exact, y_exact, 'b-', 'LineWidth', 1.5);

% Add labels and legend
xlabel('t');
ylabel('y(t)');
title('Euler Approximation of the ODE');
legend('Euler Approximation', 'Exact Solution');
grid on;
hold off;