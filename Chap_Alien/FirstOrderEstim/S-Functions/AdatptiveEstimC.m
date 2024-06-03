function  [sys, x0]  = AdatptiveEstimC(t,x,v,flag,N,Ts,P,Q)

% State vector x has 1 continuous state for \hat \theta x(1)
% input v contains the discrete part (2N) values N first values for u and
% the rest for y

if  flag == 1 % derivative of \hat theta=x(1)
    if t<=2*Ts
        sys(1,1)=0;
    else
    % Compute Y(t)= \int_{0}^{T} \left[ \frac{1}{T} Q\left(\frac{t}{T}\right)y(t)-P\left(\frac{t}{T}\right)u(t) \right] \mathrm{d} t,
    % Compute \phi(t)&=&\int_{0}^{T} P\left(\frac{t}{T}\right)y(t)\mathrm{d} t,
    int1=0;
    int2=0;
    n=1+t/Ts;
    tau=0:Ts:t-Ts;
    NewTau=tau/t;
    %P degrès 3
    PolyP=P(1).*NewTau.*NewTau+P(2).*NewTau+P(3);
    %Q degrès 2
    PolyQ=Q(1).*NewTau+Q(2);
    for i=1:n-1 
         y=v(N+i);
         u=v(i);
         f1= PolyQ(i)*y-t*PolyP(i)*u;
         f2= t*PolyP(i)*y;
         int1=int1+Ts*f1;
         int2=int2+Ts*f2;
    end;
    Y=int1;
    phi=int2;
    % Select Kappa
    kappa=2;
    % Compute m(t)=1+\kappa\phi^{2}(t)
    m=1;%+kappa*phi*phi;
    % Select gamma
    gamma1=40000000;
    gamma2=20000000;
    % derivative for adaptation algorithm
    sig=sign(phi*x(1)-Y);
    a=abs(phi*x(1)-Y);
    sys(1,1)=-phi*sig*gamma1*a; %(gamma1*a^(0.9)+gamma2*a^(2))/m;
    end;
elseif flag == 3
    sys(1,1)=-x(1); 
elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [1; 0; 1; 2*N; 0; 0]; 
    x0 = 0;
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
