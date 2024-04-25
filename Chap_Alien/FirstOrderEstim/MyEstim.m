function  [sys, x0]  = MyEstim(t,x,u,flag,N,Ts,P,Q)
if  flag == 2
    % u(1)=u stocké dans x(1) à x(N)
    % u(2)=y stocké dans x(N+1) à x(2N)
    n=1+t/Ts;%n=1 au premier appel
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
    if t<=50*Ts
        sys(1,1)=0;
    else
    int1=0;
    int2=0;
    n=1+t/Ts;
    tau=0:Ts:t-Ts;
    NewTau=tau/t;
    %P degrès 3
    PolyP=P(1).*NewTau.*NewTau+P(2).*NewTau+P(3);
    PolyQ=Q(1).*NewTau+Q(2);
    %Q degrès 2
    for i=1:n-1 
         y=x(N+i);
         u=x(i);
         f1= PolyQ(i)*y-t*PolyP(i)*u;
         f2= t*PolyP(i)*y;
         int1=int1+Ts*f1;
         int2=int2+Ts*f2;
    end;
    res=int1/(int2);
    if isnan(res)
        sys(1,1)=0; 
    else
        sys(1,1)=-res;
    end;
    end;
elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [0; 2*N; 1; 2; 0; 0]; 
    x0 = zeros(2*N,1);
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
