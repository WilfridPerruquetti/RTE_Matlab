function  [sys, x0]  = ThirdOrder_model(t,x,u,flag)
% \begin{eqnarray}
% \dot{x}_{1}&= x_2
% \dot x_2=x_3+x_1 sin(x_2)
% \dot x_3=sin(x_1+x_2+x_3)+u
% 	y&=& x_{1} 
% \end{eqnarray}


if flag == 1 % If flag = 1, return state derivatives, xDot
	sys(1,1)= x(2);
	sys(2,1)= x(3)+x(1)*sin(x(2));
    sys(3,1)=sin(x(1)+x(2)+x(3))+u;
            
elseif flag == 3 % If flag = 3, return system outputs, y
	for i=1:3
        sys(i,1)= x(i);
    end
elseif flag == 0 % If flag = 0, return initial condition data, sizes and x0
	%sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
	sys = [3; 0; 3; 1; 0; 1]; 
	x0 = [1,1,1];
else % If flag is anything else, no need to return anything since this is a continuous system
	sys = [];
end
