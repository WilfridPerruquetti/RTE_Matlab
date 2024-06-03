function[w]=Jacobi_weight(mu,k,t) %%%% fonction poids des polynomes de Jacobi dans le cas causal
w=zeros(1,max(size(t)));
w=(1-t).^mu.*t.^k;
end