function [sys,x0,str,ts] = MobileRobot30(t,x,u,flag,Params)
%'MobileRobot30' type \eqref{eq:kinematic30},
switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes;
  case 1
    sys = mdlDerivatives(t,x,u); % Calculate derivatives
  case 3
    sys = mdlOutputs(t,x,u); % Calculate outputs
  case {2, 4, 9}
    sys = [];       % Unused flags
  otherwise
    error(['unhandled flag = ',num2str(flag)]); % Error handling
end

function [sys,x0,str,ts] = mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [1;1.2;0.1];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u)
% \begin{equation}\label{eq:kinematic30}
% \begin{pmatrix}
% \dot x \\
% \dot y \\
% \dot \theta \\
% \end{pmatrix}
% =\begin{pmatrix}
% \cos(\theta) & -\sin(\theta) & 0 \\
% \sin(\theta) & \cos(\theta) & 0 \\
% 0 & 0 & 1 \\
% \end{pmatrix}\begin{pmatrix}
% v_1 \\
% v_2 \\
% \omega \\
% \end{pmatrix},
sys(1) = cos(x(3))*u(1)-sin(x(3))*u(2);
sys(2) = sin(x(3))*u(1)+cos(x(3))*u(2);
sys(3) = u(3);

function sys = mdlOutputs(t,x,u)
sys=x;
