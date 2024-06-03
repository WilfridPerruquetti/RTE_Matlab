function  [sys, x0]  = nHomDR(t,x,u,flag,paramsnHomDR)
% Recursive
% with $\alpha_i=(i+1)\alpha-i,\quad i=0,\dots,n,\quad \alpha\in\left]1-\frac{1}{n+1},1\right[ $
% alpha1=alpha \in (1-1/(n+1),1)
% alphai=i*alpha-(i-1)
n=paramsnHomDR.n;
gain=paramsnHomDR.gain;
theta=paramsnHomDR.theta;
alpha=paramsnHomDR.alpha;

if or(alpha>1,alpha<1-1/(n+1)) disp('error: alpha must belong to (1-1/n, 1)');
else
    if ne(length(gain),n+1) disp('error: gain must be a row vetor of length (n+1)');
    else
        if flag == 1
            % If flag = 1, return state derivatives, xDot
            v(1)=u;
            for i=1:n
                %k(i)=gain(i);
                k(i)=gain(i)*theta^(1/(n-i+2));
                v(i+1)=x(i+1)-k(i)*sign(x(i)-v(i))*abs(x(i)-v(i))^(i*alpha-(i-1));
                sys(i,1)=v(i+1); 
            end
                %k(n+1)=gain(n+1);
                k(n+1)=gain(n+1)*theta;
                sys(n+1,1)=-k(n+1)*sign(x(n+1)-v(n+1))*abs(x(n+1)-v(n+1))^((n+1)*alpha-n);
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
end
