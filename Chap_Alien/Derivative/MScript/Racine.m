function[tau]=Racine(mu,k,n) % Calcul la plus petite des racine du polynome p^{mu+n,k+n}_2 
a=1/2*((k+n+1)*(k+n+2)+2*(k+2+n)*(mu+2+n)+(mu+n+1)*(mu+n+2));
b=-(k+mu+3+2*n)*(k+2+n);
c=1/2*(k+1+n)*(k+2+n);
tau1=1/(2*a)*(-b-(b^2-4*a*c)^(1/2));
tau2=1/(2*a)*(-b+(b^2-4*a*c)^(1/2));
tau=min(tau1,tau2);
end