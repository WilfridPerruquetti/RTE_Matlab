function [sys,x0,str,ts] = MobileRobot21(t,x,u,flag,Params)
%'MobileRobot21' type \eqref{eq:kinematic21},
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
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [1;1.2;0.1];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u)
% \begin{pmatrix}
% \dot x \\
% \dot y \\
% \dot \theta \\
% \dot \beta_{c1}\\
% \end{pmatrix}
% =\begin{pmatrix}
% \cos(\theta+\beta_{c1}) & 0 & 0 \\
% \sin(\theta+\beta_{c1}) & 0 & 0 \\
% 0 & 1 & 0 \\
% 0 & 0 & 1\\
% \end{pmatrix}\begin{pmatrix}
% u \\
% \omega_1 \\
% \omega_2 \\
% \end{pmatrix}.
sys(1) = cos(x(3)+x(4))*u(1);
sys(2) = sin(x(3)+x(4))*u(1);
sys(3) = u(3);
sys(4) = u(4);

function sys = mdlOutputs(t,x,u)
sys=x;
