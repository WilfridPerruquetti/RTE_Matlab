% Bouncing Ball Simulation

% Parameters
g = 9.81;        % Acceleration due to gravity (m/s^2)
e = 0.8;        % Coefficient of restitution
y0 = 10;        % Initial height (m)
v0 = 0;         % Initial velocity (m/s)
dt = 0.01;      % Time step (s)
t_max = 10;     % Total simulation time (s)

% Initialize variables
t = 0:dt:t_max;          % Time vector
y = zeros(size(t));      % Position vector
v = zeros(size(t));      % Velocity vector
y(1) = y0;               % Set initial height
v(1) = v0;               % Set initial velocity

% Simulation loop
for i = 1:length(t)-1
    % Update velocity and position
    v(i+1) = v(i) - g * dt;  % Update velocity under gravity
    y(i+1) = y(i) + v(i) * dt;  % Update position
    
    % Check for collision with the ground
    if y(i+1) < 0
        y(i+1) = 0;                     % Reset position to ground level
        v(i+1) = -e * v(i);              % Apply coefficient of restitution
    end
end

% Plot results
figure;
subplot(2,1,1);
plot(t, y);
xlabel('Time (s)');
ylabel('Height (m)');
title('Bouncing Ball Height vs. Time');
grid on;

subplot(2,1,2);
plot(t, v);
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Bouncing Ball Velocity vs. Time');
grid on;