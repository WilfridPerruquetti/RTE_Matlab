function  [sys, x0]  = Sfun(t,x,u,flag,params)
% Derivatives: \dot x_c =f_D(t,x,u), dim nc
% Updates: x_{d_{k+1}}=f_U(t,x_c,x_{d_k},u), dim nd
% Outputs: y=f_O(t,x,u), dim m
% t = time
% x = (x_c,x_d) state, dim nc+nd
% u = inputs, dim p
if flag == 1 % If flag = 1, return state derivatives, xDot (xc of dim nc)
    for i=1:nc
        sys(i,1)= f_D(i);
    end
elseif flag == 2% If flag = 3, return updates (xd of dim nd)
    for i=1:nd
        sys(i,1)= f_U(i);
    end
elseif flag == 3% If flag = 3, return system outputs (y of dim m)
    for i=1:m
        sys(i,1)= f_O(i);
    end
elseif flag == 0% If flag = 0, return initial condition data, sizes and x0
%sys = [nb continuous states; nb discrete states; nb outputs; nb inputs;0; 1]; 
    sys = [nc; nd; m; p; 0; 1]; 
    x0 = zeros(nc+nd,1);
else% If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
