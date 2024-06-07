function  [sys, x0]  = Der_Alien2(t,x,u,flag,ParamAlien)
%ParamAlien=[Samp,Q,TWindow,Ts];
fin=length(ParamAlien);
Ts=ParamAlien(fin);
TWindow=ParamAlien(fin-1);
NW=TWindow/Ts

Samp=ParamAlien(1:NW+1);
Q=ParamAlien(NW+2:2*NW+2);

if  flag == 2
    
    % FIFO for discrete vector x
    % thus x is stacking y(t) as follows
    % x(1)=y(t), x(2)=y(t-Ts), x(NW+1)=y(t-TWindow)
    sys(1,1)=u; % x(1)=y(t)
    for i=0:NW-1
        sys(NW+1-i,1)=x(NW-i); 
    end;  
elseif flag == 3
    %% Calcul integrale
    int=0;
    if t <= TWindow;
    else
    for i=1:NW+1
        Hp(i)=Q(i)*x(i);
    end; 
        for j=1:NW
            int=int+0.5*Samp(j)*(Hp(j)+ Hp(j+1));   
        end;
    end;
    sys = int;
elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [0; NW+1; 1; 1; 0; 0]; 
    x0 = zeros(NW+1,1);
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
