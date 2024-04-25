function  [sys, x0]  = MyInt(t,x,u,flag,N,Ts,Poly)
% calcul int_(t-T)^t Poly(s/T) y(s) ds
% Ts= sampling => x(k Ts)
% N= nb de points dans l'intégrale TWin=N*Ts (en général petit N>=10 T=1e-3
% donc Ts très petit

if  flag == 2
    % u(1)=y stocké dans x(1) à x(N)
    n=1+t/Ts;%n=1 au premier appel
    if n<N
    % on remplit la liste de la façon suivante: y0, y1, etc yn, 0, 0
    % puis qd on en a N on décale FIFO
    for i=1:N
        if i==n sys(n,1)=u; else sys(i,1)=x(i);end;
    end;
    else
        for i=1:N-1 sys(i,1)=x(i+1); end;
        sys(N,1)=u;
    end;
    
elseif flag == 3
    n=1+t/Ts;
    if n<N
        sys(1,1)=0;
    else 
        Twin=N*Ts;
        tau=t-Twin-Ts:Ts:t;
        NewTau=tau/Twin;
        %P degrès s
        s=size(Poly);
        valeur=Poly(1);
        for i=2:s(1,2) valeur=valeur.*NewTau+Poly(i); end;
        PolyP=valeur;
        % calcul de l'intégrale
        int=0;
        for i=1:N int=int+Ts*PolyP(i)*x(i); end;
        sys(1,1)=6*int*Twin^(2);
    end;
elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [0; N; 1; 1; 0; 0]; 
    x0 = zeros(N,1);
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
