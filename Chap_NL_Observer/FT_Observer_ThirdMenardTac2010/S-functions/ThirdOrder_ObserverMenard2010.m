function  [sys, x0]  = ThirdOrder_ObserverPerru06(t,x,u,flag,params_observer)
% \begin{eqnarray}
% \dot{x}_{1}&= x_2
% \dot x_2=x_3+x_1 sin(x_2)
% \dot x_3=sin(x_1+x_2+x_3)+u
% 	y&=& x_{1} 
% \end{eqnarray}
% params_observer=[alpha;theta];
alpha=params_observer(1);
alpha1=alpha;
alpha2=2*alpha-1;
alpha3=3*alpha-2;
theta=params_observer(2);
rho=(1+81*theta^(2/3))/2;
l1=3*theta;
l2=3*theta^2;
l3=theta^3;

if flag == 1 % If flag = 1, return state derivatives, xDot
	powabs=@(x,alpha)(sign(x)*abs(x).^alpha);
    v=u(1);
	y=u(2);
    e=y-x(1);
	sys(1,1)= x(2)+l1*powabs(e,alpha1); 
    sys(2,1)= x(3)+x(1)*sin(x(2))+l2*powabs(e,alpha2); 
	sys(3,1)= sin(x(1)+x(2)+x(3))+v+l3*powabs(e,alpha3);
elseif flag == 3 % If flag = 3, return system outputs, y
        sys(1,1)= x(1);
        sys(2,1)= x(2);
        sys(3,1)= x(3);
elseif flag == 0 % If flag = 0, return initial condition data, sizes and x0
	%sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
	sys = [3; 0; 3; 2; 0; 1]; 
	x0 = zeros(3,1);
else % If flag is anything else, no need to return anything since this is a continuous system
	sys = [];
end
