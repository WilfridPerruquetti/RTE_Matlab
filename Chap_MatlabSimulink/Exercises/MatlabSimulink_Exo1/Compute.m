clear all;
clc;
A=GenMat(2,2,1)
[norm1, norm2, normInf]=MyMatNorms(A)
b=GenMat(2,1,3)
u1=GenMat(2,1,0.5)
MyIterate(A, b, u1, 100)

Id=eye(2);
Equilibrium=inv(Id-A)*b