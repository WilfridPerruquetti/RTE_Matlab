function  [sys, x0]  = SfuncI2(t,x,u,flag,ParamI2)
    T=ParamI2.T;
    Ts=ParamI2.Ts;
    k=ParamI2.k;
    Q=ParamI2.Q;
    N = round(T/Ts);
    
    switch flag
        case 0 % Initialization        
            % Number of continuous states, discrete states, outputs, inputs, etc
            sys=[0;N+2;1;1;0;0];% Initialize the state (data storage array)
            x0 = zeros(N+2,1);  % Pre-allocate memory for storing input samples

        case 2 % Update discrete state
            % Get the current time step index based on the sampling time
            idx = round(t / Ts) + 1;
            % Only store the input value if within the specified time interval
            if t <= T % Stack x=(y(0),y(Ts),y(2Ts), ...,0,Integral)
                x(idx) = u; % Store the input sample
                len=idx;
                Tlen=(idx-1)*Ts;
                tau = linspace(0, t, len);
            else % Stack x=(y(t-T), ...,y(t),Integral)
                for i=1:N x(i)=x(i+1);end;
                x(N+1)=u;
                len=N+1;
                Tlen=T;
                tau = linspace(t - T, t, len);
            end
            integrand=zeros(len,1);
            % Compute the integrand values
            for i=1:len
               integrand(i) = Q(tau(i), t, T)*x(i);
            end;
            % Apply the composite trapezoidal rule 
            if idx==1 Integral = 0; else
            Integral =(1/T^k) * (T/(2*N)) * sum(integrand(1:end-1) + integrand(2:end));%  (1 / Tlen^k) *trapz(tau, integrand);
            end;
            x(N+2)=Integral;
            
            sys = x;  % Return the updated state (stored data)
        case 3 % Output
            % Integral is store in x(N+2)
            sys= x(N+2);
        case {1, 4, 9} % Unused flags
            sys = [];
        otherwise
            error(['Unhandled flag = ', num2str(flag)]);
    end
end




