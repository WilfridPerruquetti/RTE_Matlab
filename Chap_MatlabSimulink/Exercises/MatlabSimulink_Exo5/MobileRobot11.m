function [sys,x0,str,ts] = MobileRobot11(t,x,u,flag,Params)
%'MobileRobot11' \eqref{eq:kinematic11} with $L=2.5\, [\unit{m}]$,
L=Params(1);
switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes;
  case 1
    sys = mdlDerivatives(t,x,u,L); % Calculate derivatives
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
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [1;1.2;0.1;-0.5];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u,L)
% \begin{pmatrix}
% \dot x \\
% \dot y \\
% \dot \theta \\
% \dot \beta_{c3}\\
% \end{pmatrix}
% =\begin{pmatrix}
% L \cos(\theta) \sin(\beta_{c3}) & 0 \\
% L \sin(\theta) \sin(\beta_{c3}) & 0 \\
% \cos(\beta_{c3}) & 0 \\
% 0 & 1\\
% \end{pmatrix}\begin{pmatrix}
% u \\
% \omega_1 \\
% \end{pmatrix}
sys(1) = L*cos(x(3))*sin(x(4))*u(1);
sys(2) = L*sin(x(3))*sin(x(4))*u(1);
sys(3) = cos(x(4))*u(1);
sys(4) = u(2);

function sys = mdlOutputs(t,x,u)
sys=x;
