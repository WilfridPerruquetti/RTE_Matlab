function I2 = FuncComputeI2(y_func, t, T, Ts, k, Q)
    % Compute Number of subintervals
    N = round(T/Ts);
    
    % Compute tau values
    tau = linspace(t - T, t, N+1);
    
    % Compute the integrand values
    integrand = Q(tau, t, T) .* y_func(tau);
    
    % Apply the trapezoidal rule
    I2 = (1 / T^k) * trapz(tau, integrand);
    % or I2=1/(2*N*T^(k-1))) * sum(integrand(1:end-1) + integrand(2:end));
end

