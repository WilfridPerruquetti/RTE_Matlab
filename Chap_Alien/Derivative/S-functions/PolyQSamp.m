function[Q,Samp,NW]=PolyQSamp(ParamAlienInit) % compute Q, Samp (Sampling intervales) and intervale for integration
Ts=ParamAlienInit(1);
TWindow=ParamAlienInit(2);
n=ParamAlienInit(3);
mu=ParamAlienInit(4);
k=ParamAlienInit(5);
q=ParamAlienInit(6);

NW=TWindow/Ts;
tau=Racine(mu,k,n);

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
end