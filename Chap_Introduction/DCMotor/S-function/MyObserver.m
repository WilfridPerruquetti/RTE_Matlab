function  [sys, x0]  = Myobserver(t,x,u,flag)

umax=10;
Observer.z=0.7;
Observer.tr=0.4;
Observer.wn=2.9/(Observer.tr);
Observer.poly=[1 2*Observer.z*Observer.wn Observer.wn*Observer.wn];
Observer.poles=roots(Observer.poly);

if flag == 1 % If flag = 1, return state derivatives, xDot
    v=u(1);
    theta=u(2);
    b0=u(3);
    a0=u(4);
    a1=u(5);
    A=[0 1;-a0 -a1];
    C=[1 0];
    L_Matlab=place(A',C',Observer.poles)';
    l1=L_Matlab(1);
    l2=L_Matlab(2);
    e=theta-x(1);
    
    sys(1,1)= x(2)+l1*e;
    sys(2,1)= -a0*x(1)-a1*x(2)+b0*v+l2*e;

elseif flag == 3 % If flag = 3, return system outputs, y
    sys(1,1) = x(1);
	sys(2,1) = x(2);
    
elseif flag == 0 % If flag = 0, return initial condition data, sizes and x0
   %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [2; 0; 2; 5; 0; 0];  
    x0 = [0;0];

else 
    % If flag is anything else, no need to return anything
    % since this is a continuous system
    sys = [];
end
