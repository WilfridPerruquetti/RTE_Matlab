function [sys,x0,str,ts] = BallBeam(t,x,u,flag)
m=0.1;
g=9.81;
J=0.05;
switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes();
  case 1
    sys = mdlDerivatives(t,x,u,m,g,J); % Calculate derivatives
  case 3
    sys = mdlOutputs(x); % Calculate outputs
  case {2, 4, 9}
    sys = [];       % Unused flags
  otherwise
    error(['unhandled flag = ',num2str(flag)]); % Error handling
end
% End 

%==============================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the 
% S-function.
%==============================================================
function [sys,x0,str,ts] = mdlInitializeSizes()
sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [1;0;-1;0];
str = [];
ts  = [0, 0];
% End of mdlInitializeSizes.

%==============================================================
% mdlDerivatives
% Compute derivatives for continuous states.
%==============================================================
function sys = mdlDerivatives(t,x,u,m,g,J)
sys(1) = x(2);
sys(2) = -g*sin(x(3))+x(1)*x(3)*x(3);
sys(3) = x(4);
sys(4) = (u-2*m*x(1)*x(2)*x(4)-m*g*x(1)*cos(x(3)))/(m*x(1)*x(1)+J);
% End of mdlDerivatives.

%==============================================================
% mdlOutputs
% Return the output vector for the S-function.
%==============================================================
function sys = mdlOutputs(x)
% Return states
  sys = x;
% End of mdlOutputs.