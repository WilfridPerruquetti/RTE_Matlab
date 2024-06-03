function  [sys, x0]  = Der_Alien(t,x,u,flag,Ts,TWindow,n,mu,k,q)
N=TWindow/Ts;
tau=Racine(mu,k,n)*TWindow;
if  flag == 2
    % FIFO
    for i=0:N-1
        sys(N+1-i,1)=x(N+1-i-1);
    end;
       sys(1,1)=u
elseif flag == 3
    %% Discretisation de [0,1] pour le calcul integrale
    s=0:1/N:1; 
    %% Initialisation
    r=k;
    Q = zeros(1, N+1);
    Samp = zeros(1, N+1);
    for i=0:q
        for j=0:i
            a=k+j;b=mu+i-j;
            A=factorial(n)/(beta(n+a+1,n+b+1)*(-TWindow)^n);
            P=1/(1+r)*(1-s).^b.*s.^(a-r).*Jacobi_polynomial(b,a,n,s);
            Q=Q+A*Jacobi_polynomial(mu+n,k+n,i,tau)*(-1)^(i+j)*factorial(i)/(factorial(j)*factorial(i-j))*(2*i+k+mu+2*n+1)/(i+k+mu+2*n+1)*P;   
        end
    end
for i=0:N-1
    Samp(i+1)=((i+1)/N)^(1+r)-(i/N)^(1+r);
end
    %% Calcul integrale
    int=0;
    yt=x;
    if t <= TWindow;
    else
    Hp=Q.*(yt); 
        for j=1:length(Q)-1
            int=int+0.5*Samp(j)*(Hp(j)+ Hp(j+1));   
        end;
    end;
    sys = int;
elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [0; N+1; 1; 1; 0; 0]; 
    x0 = zeros(N+1,1);
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
