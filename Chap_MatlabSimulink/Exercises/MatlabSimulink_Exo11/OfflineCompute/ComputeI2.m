% Parameters
t = 1.5; % Example time value
T = 0.1; % Given T value
Ts= 0.005; % Sampling period
k = 4; % Given k value

% Define the polynomial Q(tau, t, T)
Q = @(tau, t, T) -60 * (7*t^2 - 14*t.*tau + 7*tau.^2 + t*T - T.*tau - 2*T^2);
% Define the signal y(t)
y = @(t) sin(t);

if t - T<0 % data stored on the interval [0,t]
    N = round(t/Ts); % Number of subintervals
    tau = linspace(0, t, N+1); % tau values from t-T to t with N subintervals
else
    N = round(T/Ts); % Number of subintervals
    tau = linspace(t - T, t, N+1); % tau values from t-T to t with N subintervals
end;
% Compute the values of the function to be integrated
f_values = Q(tau, t, T) .* y(tau);
% Apply the composite trapezoidal rule
I2 = (1/T^k) * (T/(2*N)) * sum(f_values(1:end-1) + f_values(2:end));
% Display the result
fprintf('t = %.2f\n', t);
fprintf('I2(y,t,T) = %.5f\n', I2);