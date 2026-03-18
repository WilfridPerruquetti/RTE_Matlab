function I2 = FuncComputeI2(y_func, t, T, Ts, k, Q)
    if t - T<0 % data stored on the interval [0,t]
        N = round(t/Ts); % Number of subintervals
        tau = linspace(0, t, N+1); % tau values from t-T to t with N subintervals
    else
        N = round(T/Ts); % Number of subintervals
        tau = linspace(t - T, t, N+1); % tau values from t-T to t with N subintervals
    end;
    
    % Compute the integrand values
    integrand = Q(tau, t, T) .* y_func(tau);
    % Apply the trapezoidal rule
    I2 = (1 / T^k) * trapz(tau, integrand);
    % or I2=1/(2*N*T^(k-1))) * sum(integrand(1:end-1) + integrand(2:end));
end

