function I1 = FuncComputeI1(y_func, t, Ts, P)
    % Compute Number of subintervals
    N = round(t/Ts);

    % Compute tau values
    tau = linspace(0, 1, N+1);
    
    % Compute the integrand values
    integrand = P(tau) .* y_func(t * tau);
    
    % Apply the trapezoidal rule
    I1 = trapz(tau, integrand);
    % or I1=sum(integrand(1:end-1) + integrand(2:end))/(2*N);
end

