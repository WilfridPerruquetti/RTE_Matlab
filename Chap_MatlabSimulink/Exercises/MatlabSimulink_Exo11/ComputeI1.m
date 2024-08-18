% Parameters
t = 1; % Example time value
Ts = 0.005; % Sampling period
N = round(t/Ts); % Number of subintervals

tau = linspace(0, 1, N+1); % tau values from 0 to 1 with N subintervals

% Define the polynomial P(tau)
P = @(tau) 2 - 3*tau;

% Define the signal y(t)
y = @(t) sin(t);

% Compute the values of the function to be integrated
f_values = P(tau) .* y(t * tau);

% Apply the composite trapezoidal rule
I1 = (1/(2*N)) * sum(f_values(1:end-1) + f_values(2:end));

% Display the result
fprintf('I1(y,t) = %.5f\n', I1);