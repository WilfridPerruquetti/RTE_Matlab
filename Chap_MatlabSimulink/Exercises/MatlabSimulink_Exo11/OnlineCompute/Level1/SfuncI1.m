function  [sys, x0]  = SfuncI1(t,x,u,flag,ParamI1)
    % Extract parameters
    Ts = ParamI1.Ts;   % Sampling time
    P = ParamI1.P;     % Function P(tau)
    N = ParamI1.N;     % Number of discrete time steps for sampling
    
    switch flag
        case 0 % Initialization        
            % Specify system sizes [number of continuous states, number of discrete states,
            % number of outputs, number of inputs, direct feedthrough flag, number of sample times]
            sys = [0; N + 2; 1; 1; 0; 0];  % No continuous states, N+2 discrete states, 1 output, 1 input
            % Initialize the state vector (discrete states), which includes N+1 samples plus an integral
            x0 = zeros(N + 2, 1);  % Pre-allocate memory for storing input samples and the integral

        case 2 % Update discrete state
            % Stack x=(y(0), y(Ts), ....,Integral)
            % Get the current time step index based on the sampling time
            idx = round(t / Ts) + 1;
            % Only store the input value if within the specified time interval
            if t <= N*Ts
                x(idx) = u;  % Store the input sample
            end
            % Prepare the integrand for trapezoidal integration
            integrand = zeros(idx, 1);  % Pre-allocate space for the integrand values
            % Compute tau values from 0 to 1 (normalized time)
            tau = linspace(0, 1, idx);
            % Populate the integrand with P(tau) * stored input samples x(i)
            for i = 1:idx
               integrand(i) = P(tau(i)) * x(i);
            end
            % Compute the integral using the trapezoidal rule
            if idx == 1
                Integral = 0;  % No integration is possible with a single point
            else
                Integral = trapz(tau, integrand);  % Use the trapezoidal rule to compute the integral
                % or %sum(integrand(1:end-1) + integrand(2:end))/(2*round( t / Ts));
            end
            % Store the computed integral in the last position of the state vector
            x(N + 2) = Integral;
            % Return the updated discrete state (x)
            sys = x;
            
        case 3  % Output block
            % Output the computed integral, which is stored in the (N+2)-th element of the state vector
            sys = x(N + 2);
        
        case {1, 4, 9}  % Handle other unused flags
            % No operation for unused flags
            sys = [];
        
        otherwise
            % Error handling for unhandled flags
            error(['Unhandled flag = ', num2str(flag)]);
    end
end
    




