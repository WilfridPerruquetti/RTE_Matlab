%% Polynôme de Jacobi dans le cas Causal
% \begin{equation} \label{Eq_def__jacobi}
% P_{n}^{(\mu,\kappa)}(\tau)=
% \displaystyle\sum_{j=0}^{n}\binom{n+\mu}{j}%
% \binom{n+\kappa}{n-j}\left(  \tau-1 \right)  ^{n-j} \tau^{j}.
% \end{equation}
% Nota:
% \binom{n+\mu}{j}=(n+\mu)!/((j!)(n+\mu-j)!)
% gamma(x+1)=x!

function[p]=Jacobi_polynomial(mu,k,n,t) 
a=0;b=0;
p=zeros(1,max(size(t)));c=p;d=p;
for j=0:n
    a=gamma(n+mu+1)/(gamma(j+1)*gamma(n+mu-j+1));
    b=gamma(n+k+1)/(gamma(n-j+1)*gamma(k+j+1));
    c=(t-1).^(n-j);
    d=t.^(j);
    p=p+a*b*c.*d;
end
end