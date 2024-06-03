function  [sys, x0]  = nFxTHomDR(t,x,u,flag,paramsnFxTHomDR)
% Recursive
% with $\alpha_i=(i+1)\alpha-i,\quad i=0,\dots,n,\quad \alpha\in\left]1-\frac{1}{n+1},1\right[ $
% alpha1=alpha \in (1-1/(n+1),1)
% alphai=i*alpha-(i-1)
n=paramsnFxTHomDR.n;
gain0=paramsnFxTHomDR.gain0; 
gainInfty=paramsnFxTHomDR.gainInfty; 
theta0=paramsnFxTHomDR.theta0;
thetaInfty=paramsnFxTHomDR.thetaInfty;
alpha0=paramsnFxTHomDR.alpha0; % between 1-1/(n+1),1
alphaInfty=paramsnFxTHomDR.alphaInfty

if or(alpha0>1,alpha0<1-1/(n+1)) disp('error: alpha0 must belong to (1-1/n, 1)');
else
    if ne(length(gain0),n+1) disp('error: gain must be a row vetor of length (n+1)');
    else
        if flag == 1
            % If flag = 1, return state derivatives, xDot
            v(1)=u;
            for i=1:n
                ko=gain0(i)*theta0^(1/(n-i+2));
                kInfty=gainInfty(i)*thetaInfty^(1/(n-i+2));
                CorrO=ko*abs(x(i)-v(i))^(i*alpha0-(i-1));
                CorrInfty=kInfty*abs(x(i)-v(i))^(i*alphaInfty-(i-1));
                v(i+1)=x(i+1)-sign(x(i)-v(i))*(CorrO+CorrInfty);
                sys(i,1)=v(i+1); 
            end
                ko=gain0(n+1)*theta0;
                kInfty=gainInfty(n+1)*thetaInfty;
                CorrO=ko*abs(x(n+1)-v(n+1))^((n+1)*alpha0-(n));
                CorrInfty=kInfty*abs(x(i)-v(i))^((n+1)*alphaInfty-(n));
                sys(n+1,1)=-sign(x(n+1)-v(n+1))*(CorrO+CorrInfty);
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
