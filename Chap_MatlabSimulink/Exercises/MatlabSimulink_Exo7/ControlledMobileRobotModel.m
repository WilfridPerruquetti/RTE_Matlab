function [sys,x0,str,ts] = ControlledMobileRobotModel(t,x,u,flag,Params)
dperiod = 0.5;
doffset = 0;
switch flag
    case 0
        % Initialization
        [sys, x0, str, ts] = mdlInitializeSizes(dperiod,doffset);
    case 1
        % Derivatives
        sys = mdlDerivatives(t, x, u,Params);
    case 2
        % Update
        sys = mdlUpdate(t, x, u, Params,dperiod,doffset);
    case 3
        % Outputs
        sys = mdlOutputs(t, x, u);
    case 4
        sys = [];
    case 9
        % Terminate
        sys = mdlTerminate(t, x, u);
    otherwise
        % Unhandled flag
        error(['Unhandled flag = ', num2str(flag)]);
end

function [sys, x0, str, ts] = mdlInitializeSizes(dperiod,doffset)
% Define the sizes, initial conditions, and sample times for the S-function
sizes = simsizes;
sizes.NumContStates  = 2; % [x; dx/dt]
sizes.NumDiscStates  = 4; % [u_n_minus1;u_n;x_n;v_n]
sizes.NumOutputs     = 6; % continuous and discrete states
sizes.NumInputs      = 1; % u(t)
sizes.DirFeedthrough = 1; % Direct feedthrough
sizes.NumSampleTimes = 2; % 2 sample time are needed
sys = simsizes(sizes);
x0 = [10; -1.2; 0.1; 0.2;0.2;-0.1]; % Initial conditions for continuous states
str = [];    % str is always an empty matrix
ts  = [0 0 % Continuous sample time
       dperiod doffset];% Discrete sample time

function sys = mdlDerivatives(t, x, u,Params)
% Params=[m;b;k;a0;a1;b0;b1;c0;c1];
m = Params(1); % Mass
b = Params(2); % Damping coefficient
k = Params(3); % Spring constant
% Compute the derivatives for the continuous states
dx1 = x(2);
dx2 = (x(4)-b*x(2) - k*x(1)) / m;
sys = [dx1; dx2];

function sys = mdlUpdate(t, x, u, Params,dperiod,doffset)
% Params=[m;b;k;a0;a1;b0;b1;c0;c1];
a0=Params(4);a1=Params(5);b0=Params(6);b1=Params(7);c0=Params(8);c1=Params(9);
if t==0 sys = []; 
elseif abs(round((t-doffset)/dperiod)-(t-doffset)/dperiod) < 1e-8
    x_n = x(1);
    x_n_minus1 = x(5);
    v_n = x(2);
    v_n_minus1 = x(6);
    u_n_minus1 = x(3);
    u_n= x(4);
    u_n_new = -(a1*u_n + a0*u_n_minus1) + b1*x_n + b0*x_n_minus1 + c1*v_n + c0*v_n_minus1;
    sys = [x(4);u_n_new;x_n;v_n]; % Update the discrete states
else
  sys = [];   % This is not a sample hit, so return an empty 
end

function sys = mdlOutputs(t, x, u)
% Output the current value of x
sys = x;

function sys = mdlTerminate(t, x, u)
% Perform any necessary tasks at the end of the simulation
sys = [];
