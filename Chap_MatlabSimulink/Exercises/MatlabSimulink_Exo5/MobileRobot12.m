function [sys,x0,str,ts] = MobileRobot12(t,x,u,flag,Params)
%'MobileRobot12' \eqref{eq:kinematic12} with $L=2.5\, [\unit{m}]$,
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
sizes.NumContStates  = 5;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [1;1.2;0.1;-0.2;0.5];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u,L)
% \begin{pmatrix}
%   \dot x \\
%   \dot y \\
%   \dot \theta \\
%   \dot \beta_{c1}\\
%   \dot \beta_{c2}\\
% \end{pmatrix}
% =\begin{pmatrix}
%    L(\sin(\beta_{c1}) \cos(\theta+\beta_{c2})+\sin(\beta_{c2}) \cos(\theta+\beta_{c1})) & 0 & 0 \\
%    L (\sin(\beta_{c1}) \sin(\theta+\beta_{c2})+\sin(\beta_{c2}) \sin(\theta+\beta_{c1}))  & 0 & 0 \\
%    \sin(\beta_{c2}-\beta_{c1})  & 0 & 0 \\
%   0 & 1 & 0 \\
%   0 & 0 & 1\\
%  \end{pmatrix}\begin{pmatrix}
%   u \\
%   \omega_1 \\
%   \omega_2 \\
% \end{pmatrix}.
sys(1) = L*(sin(x(4))*cos(x(3)+x(5))*u(1)+sin(x(5))*cos(x(3)+x(4))*u(2));
sys(2) = L*(sin(x(4))*sin(x(3)+x(5))*u(1)+sin(x(5))*sin(x(3)+x(4))*u(2));
sys(3) = sin(x(5)-x(4))*u(1);
sys(4) = u(2);
sys(5) = u(3)

function sys = mdlOutputs(t,x,u)
sys=x;
