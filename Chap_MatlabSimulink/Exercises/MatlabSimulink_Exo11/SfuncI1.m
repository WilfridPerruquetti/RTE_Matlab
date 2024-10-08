function  [sys, x0]  = SfuncI1(t,x,u,flag,ParamI1)
    Ts=ParamI1.Ts;
    P=ParamI1.P;
    
    switch flag
        case 0 % Initialization
            %sys = [contState; discState; output; input;0; 0]; 
            sys = [0; N; 1; 1; 0; 0];
            x0 = zeros(N,1);
        case 2 % Update discrete state
            for i=1:N-1
                sys(i)=x(i+1);
            end; 
            sys(N)=u;
            % x=(y(0))
        case 3 % Outputs
            tau = linspace(0, 1, N+1);
            % Compute the integrand values
            integrand = P(tau) .* x;
            % Apply the trapezoidal rule
            sys = trapz(tau, integrand);
        case {1, 4, 9} % Unused flags
            sys = [];
        otherwise
            error(['Unhandled flag = ', num2str(flag)]);
    end
end;




