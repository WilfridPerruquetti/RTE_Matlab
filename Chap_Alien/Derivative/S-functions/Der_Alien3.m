function  [sys, x0]  = Der_Alien3(t,x,u,flag,Ts,TWindow)
Nw=TWindow/Ts;
if  flag == 2    
    % FIFO
    sys(1,1)=u
    for i=0:Nw-1
        sys(Nw+1-i,1)=x(Nw-i);
    end;
elseif flag == 3
    %% Initialisation
    hInt=1/Nw;
    int=0;
    %% Calcul integrale
    if t <= TWindow;
    else
        %% Discretisation de [0,1] pour le calcul integrale
        s=0:hInt:1; 
        Q = zeros(1, Nw+1);
        %Q = 6*(1-2.*s)/TWindow;%1rst order
        Q = (14.*s-15.*s.*s-2)/(TWindow*TWindow);%1rst order
        lenQ=length(Q);
        Hp=zeros(1, Nw+1);
        for i=1:lenQ
            Hp(i)=Q(i)*x(i);
        end;
        for j=1:Nw
            int=int+0.5*hInt*(Hp(j)+ Hp(j+1));   
        end;
        sys = int;
     end;
 elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [0; Nw+1; 1; 1; 0; 0]; 
    x0 = zeros(Nw+1,1);
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
