clc;
clear all;
poly=conv(conv([1 1],[1 1]),[1 2]);
roots(poly)
A=[0 1 0;0 0 1;4 5 2];

eig(A);

[V,J] = jordan(A)

