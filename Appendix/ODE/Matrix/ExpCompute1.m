myp=conv([1 1],[1 2])
a0=-2;
a1=-3;
A=[0 1;a0 a1];
p=poly(A);
ro=roots(p);
delta=a1*a1-4*(-a0);
vp1=-(-a1+sqrt(delta))/2;
vp2=-(-a1-sqrt(delta))/2;
[P,D]=eig(A);

P^(-1)*A*P

-2+sqrt(2)

-2-sqrt(2)

%x_2=l*x_1
%-2x1-3x2=lx2
%-2x1-3lx1=l^2x1

%x2=-x1 (1 -1) pour -1
%-2x1+3x1=x1


%x2=-2x1 (1 -2) pour -2
%-2x1+6x1=4x1

MyP=[1 1;-1 -2]

MyP^(-1)*A*MyP


x = sym('x')
y = sym('y')
D = sym('D')

D=[x 0;0 y]

MyP*D*MyP^(-1)