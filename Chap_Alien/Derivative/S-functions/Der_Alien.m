function  [sys, x0]  = Der_Alien(t,x,u,flag,ParamAlienInit)
%ParamAlienInit=[Ts;TWindow;n;mu;k;q];
Ts=ParamAlienInit(1);
TWindow=ParamAlienInit(2);
NW=TWindow/Ts;
n=ParamAlienInit(3);
mu=ParamAlienInit(4);
k=ParamAlienInit(5);
q=ParamAlienInit(6);
tau=Racine(mu,k,n);

if  flag == 2
    % FIFO for discrete vector x
    % thus x is stacking y(t) as follows
    % x(1)=y(t), x(2)=y(t-Ts), x(NW+1)=y(t-TWindow)
    sys(1,1)=u; % x(1)=y(t)
    for i=0:NW-1
        sys(NW+1-i,1)=x(NW-i); 
    end;  
elseif flag == 3
Q = zeros(1, NW+1);
Samp = zeros(1, NW+1);
%%% r=kappa
r=k;
%% discretisation of interval [0,1]
s=0:1/NW:1; 
%%% Initialisation
for i=0:q
    for j=0:i
        a=k+j;b=mu+i-j;
        A=factorial(n)/(beta(n+a+1,n+b+1)*(-TWindow)^n);
        P=1/(1+r)*(1-s).^b.*s.^(a-r).*Jacobi_polynomial(b,a,n,s);
        Q=Q+A*Jacobi_polynomial(mu+n,k+n,i,tau)*(-1)^(i+j)*factorial(i)/(factorial(j)*factorial(i-j))*(2*i+k+mu+2*n+1)/(i+k+mu+2*n+1)*P;   
    end
end

for i=0:NW-1
    Samp(i+1)=((i+1)/NW)^(1+r)-(i/NW)^(1+r);
end
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
