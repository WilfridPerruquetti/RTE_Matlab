% Parameters
t = 3; % Example time value
Ts = 0.005; % Sampling period
N = round(t/Ts); % Number of subintervals

% tau values from 0 to 1 with N subintervals
tau = linspace(0, 1, N+1); 

% Define the polynomial P(tau)
P = @(tau) 2 - 3*tau;

% Define the signal y(t)
y = @(t) sin(t);

% Compute the values of the function to be integrated
integrand = P(tau) .* y(t * tau);

% Apply the composite trapezoidal rule
I1 = trapz(tau, integrand);
%or
% I1 = sum(integrand(1:end-1) + integrand(2:end))/(2*N);

% Display the result
fprintf('I1(y,t) = %.5f\n', I1);