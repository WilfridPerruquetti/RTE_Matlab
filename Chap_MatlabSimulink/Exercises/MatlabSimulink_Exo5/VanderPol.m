function [sys,x0,str,ts] = VanderPol(t,x,u,flag,Params)
mu=Params(1);
A=Params(2);
omega=Params(3);
switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes;
  case 1
    sys = mdlDerivatives(t,x,u,mu,A,omega); % Calculate derivatives
  case 3
    sys = mdlOutputs(t,x,u); % Calculate outputs
  case {2, 4, 9}
    sys = [];       % Unused flags
  otherwise
    error(['unhandled flag = ',num2str(flag)]); % Error handling
end

function [sys,x0,str,ts] = mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0.1;0.2];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u,mu,A,omega)
%\ddot x+\mu(1-x^2) \dot x+x=A \cos(\omega t).
sys(1) = x(2);
sys(2) = A*cos(omega*t)-mu*(1-x(1)^2);

function sys = mdlOutputs(t,x,u)
sys=x;
