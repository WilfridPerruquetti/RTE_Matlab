function  [sys, x0]  = Sfun(t,x,u,flag,params)
% Derivatives: \dot x_c =f_D(t,x,u), dim nc
% Updates: x_{d_{k+1}}=f_U(t,x_c,x_{d_k},u), dim nd
% Outputs: y=f_O(t,x,u), dim m
% t = time
% x = (x_c,x_d) state, dim nc+nd
% u = inputs, dim p
switch flag,
  case 0         % Initialization
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb continuous states; nb discrete states; nb outputs; nb inputs;0; 1]; 
    sys = [nc; nd; m; p; 0; 1]; 
    x0 = zeros(nc+nd,1);
  case 1        % Derivatives
    % If flag = 1, return state derivatives, xDot (xc of dim nc)
    for i=1:nc
        sys(i,1)= f_D(i);
    end
    case 2      % Updates
    % If flag = 2, return updates (xd of dim nd)
    for i=1:nd
        sys(i,1)= f_U(i);
    end
    case 3        % Calculate outputs
    % If flag = 3, return system outputs (y of dim m)
    for i=1:m
        sys(i,1)= f_O(i);
    end
  case {4, 9}
    sys = [];       % Unused flags
    otherwise
    error(['unhandled flag = ',num2str(flag)]); % Error handling
end

