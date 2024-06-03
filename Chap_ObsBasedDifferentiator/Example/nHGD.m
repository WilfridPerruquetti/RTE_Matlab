function  [sys, x0]  = nHGD(t,x,u,flag,paramsnHGD)
% High Gain Differentiator
%\begin{eqnarray}
% \dot z_0 &=& z_1-\ell_{0} \theta (z_0 - y(t)) ,\\
% \dot z_1 &=&z_2 -\ell_{1}\theta^2 (z_0 - y(t)),\\
% \ldots &=& \ldots,\\
% \dot z_{n-1} &=& z_n -\ell_{n-1}\theta^{n}  (z_0 - y(t)),\\
% \dot z_{n} &=& -\ell_{n}\theta^{n+1}(z_0 - y(t))
% \end{eqnarray}
n=paramsnHGD.n;
gain=paramsnHGD.gain;
theta=paramsnHGD.theta;

if ne(length(gain),n+1) disp('error: gain must be a row vector of length'); (n+1)
    else
        if flag == 1
            % If flag = 1, return state derivatives, xDot
            for i=1:n
                k(i)=gain(i)*theta^i;
                sys(i,1)= x(i+1)-k(i)*(x(1)-u);
            end
                k(n+1)=gain(n+1)*theta^(n+1);
                sys(n+1,1)=-k(n+1)*(x(1)-u);
        elseif flag == 3
            % If flag = 3, return system outputs, y
            for i=1:n+1
                sys(i,1)= x(i);
            end
        elseif flag == 0
            % If flag = 0, return initial condition data, sizes and x0
            %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
            disp(n)
            sys = [n+1; 0; n+1; 1; 0; 0]; 
            x0 = zeros(n+1,1);
        else
            % If flag is anything else, no need to return anything since this is a continuous system
            sys = [];
        end
end
