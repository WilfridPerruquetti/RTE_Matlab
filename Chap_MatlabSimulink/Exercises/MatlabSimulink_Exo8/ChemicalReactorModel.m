function [sys,x0,str,ts] = ChemicalReactorModel(t,x,u,flag,Params)

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
% Params=[a0;a1;a2;b;c1;c2;c3;d;Ts];
Ts=Params(9);
sizes = simsizes;
sizes.NumContStates  = 3; % [T; dT/dt;d2T/dt2]
sizes.NumDiscStates  = 2; % [u_k;T_kminus1]
sizes.NumOutputs     = 5; % continuous and discrete states
sizes.NumInputs      = 1; % u(t)
sizes.DirFeedthrough = 0; % Direct feedthrough
sizes.NumSampleTimes = 2; % 2 sample times are needed
sys = simsizes(sizes);
x0 = [18; -1.2; 0.1; 0.2;18]; % Initial conditions for continuous states
str = [];    % str is always an empty matrix
ts  = [0 0 % Continuous sample time
       Ts 0];% Discrete sample time

function sys = mdlDerivatives(t, x, u,Params)
% Params=[a0;a1;a2;b;c1;c2;c3;d;Ts];
a0 = Params(1); 
a1 = Params(2); 
a2 = Params(3);
b = Params(4);
% Compute the derivatives for the continuous states
dx1 = x(2);
dx2 = x(3);
dx3 = b*x(4)-a0*x(1)-a1*x(2)-a2*x(3);%u
sys = [dx1; dx2; dx3];

function sys = mdlUpdate(t, x, u, Params,dperiod,doffset)
% Params=[a0;a1;a2;b;c1;c2;c3;d;Ts];
c1=Params(5);c2=Params(6);c3=Params(7);d=Params(8);Ts=Params(9);
if t==0 sys = []; 
elseif abs(round(t/Ts)-t/Ts) < 1e-8
    u_k = x(4);
    T_kminus1 = x(5);
    u_kplus1 = c1*x(1) + c2*T_kminus1+c3*u_k+d;
    sys = [u_kplus1;x(1)]; % Update the discrete states
else
  sys = [];   % This is not a sample hit, so return an empty 
end

function sys = mdlOutputs(t, x, u)
% Output the current value of x
sys = x;

function sys = mdlTerminate(t, x, u)
% Perform any necessary tasks at the end of the simulation
sys = [];
