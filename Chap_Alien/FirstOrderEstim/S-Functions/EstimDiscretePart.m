function  [sys, x0]  = EstimDiscretePart(t,x,u,flag,N,Ts)

% State vector x has 2N (discrete) components x(1)...x(2N)

if  flag == 2
    % u(1)=u is stacked in [x(2), ...,x(N+1)]
    % u(2)=y is stacked in [x(N+2),...,x(2N+1)]
    
    n=1+t/Ts;%n=1 when called for the first time
    % on rempli la liste de la façon suivante: y0, y1, etc yn, 0, 0
    for i=1:N
        if i==n
        sys(n,1)=u(1);
        sys(N+n,1)=u(2);
        else
        sys(i,1)=x(i);
        sys(N+i,1)=x(N+i);
        end;
    end; 
elseif flag == 3
    sys=x; 
elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [0; 2*N; 2*N; 2; 0; 0]; 
    x0 = zeros(2*N,1);
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
