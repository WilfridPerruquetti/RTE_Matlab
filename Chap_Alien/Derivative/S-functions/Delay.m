function  [sys, x0]  = Delay(t,x,u,flag,Ts,TWindow)
N=TWindow/Ts;
if  flag == 2
    % on rempli la liste de la façon suivante: y0, y1, etc yn, 0, 0
%     for i=1:N
%         sys(i,1)=x(i+1);
%     end;
%        sys(N+1,1)=u;% FIFO
    for i=0:N-1
        sys(N+1-i,1)=x(N+1-i-1);
    end;
       sys(1,1)=u

elseif flag == 3
    sys = x(N+1);
elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [0; N+1; 1; 1; 0; 0]; 
    x0 = zeros(N+1,1);
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
