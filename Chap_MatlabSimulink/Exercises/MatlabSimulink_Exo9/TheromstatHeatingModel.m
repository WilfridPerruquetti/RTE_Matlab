function [sys,x0,str,ts] = TheromstatHeating(t,x,u,flag,Params)
switch flag
    case 0
        % Initialization
        [sys, x0, str, ts] = mdlInitializeSizes(Params);
    case 1
        % Derivatives
        sys = mdlDerivatives(t, x, u,Params);
    case 2
        % Update
        sys = mdlUpdate(t, x, u, Params);
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

function [sys, x0, str, ts] = mdlInitializeSizes(Params)
% Define the sizes, initial conditions, and sample times for the S-function
%Params=[C;k;P;Tamb;Tlow;Thigh;Ts];
sizes = simsizes;
sizes.NumContStates  = 1; % T
sizes.NumDiscStates  = 1; % uk
sizes.NumOutputs     = 2; % continuous and discrete states
sizes.NumInputs      = 1; % u(t)
sizes.DirFeedthrough = 0; % Direct feedthrough
sizes.NumSampleTimes = 1; % 2 sample times are needed
sys = simsizes(sizes);
x0 = [5;0]; % Initial conditions for continuous and discrete states
str = [];    % str is always an empty matrix
ts  = [0 0]; % Continuous sample time

function sys = mdlDerivatives(t, x, u,Params)
% Params=[C;k;P;Tamb;Tlow;Thigh;Ts];
C = Params(1); 
k = Params(2); 
P = Params(3); 
Tamb = Params(4);
% Compute the derivatives for the continuous states
dx = (-k*(x(1)-Tamb)+P*x(2))/C;
sys = dx;

function sys = mdlUpdate(t, x, u, Params)
% Params=[C;k;P;Tamb;Tlow;Thigh;Ts];
Tlow=Params(5);Thigh=Params(6);
if x(1)<Tlow
    sys = 1; % Update the discrete states
elseif x(1)>Thigh
    sys = 0; % Update the discrete states
else
  sys = x(2);   % Keep the control 
end

function sys = mdlOutputs(t, x, u)
% Output the current value of x
sys = x;

function sys = mdlTerminate(t, x, u)
% Perform any necessary tasks at the end of the simulation
sys = [];
