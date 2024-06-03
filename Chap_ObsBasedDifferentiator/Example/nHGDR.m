function  [sys, x0]  = nHGDR(t,x,u,flag,paramsnHGDR)
% High Gain Differentiator Recursive 
n=paramsnHGDR.n;
gain=paramsnHGDR.gain;
theta=paramsnHGDR.theta;

if ne(length(gain),n+1) disp('error: gain must be a row vector of length'); (n+1)
    else
        if flag == 1
            % If flag = 1, return state derivatives, xDot
            v(1)=u;
            for i=1:n
                k(i)=gain(i)*theta^i;
                v(i+1)=x(i+1)-k(i)*(x(i)-v(i))
                sys(i,1)= v(i+1);
            end
                k(n+1)=gain(n+1)*theta^(n+1);
                sys(n+1,1)=-k(n+1)*(x(n+1)-v(n+1));
        elseif flag == 3
            % If flag = 3, return system outputs, y
            for i=1:n+1
                sys(i,1)= x(i);
            end
        elseif flag == 0
            % If flag = 0, return initial condition data, sizes and x0
            %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
            sys = [n+1; 0; n+1; 1; 0; 0]; 
            x0 = zeros(n+1,1);
        else
            % If flag is anything else, no need to return anything since this is a continuous system
            sys = [];
        end
end
