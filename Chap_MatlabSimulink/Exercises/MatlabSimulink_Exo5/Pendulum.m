function [sys,x0,str,ts] = Pendulum(t,x,u,flag,Params)
%'Pendulum' \eqref{eq:ModelPendulum} with $g=9.81 \unit{\a}, \ell=1\, [\unit{\metre}], m=0.1\, [\unit{\kg}], \delta = 0.1\, [\unit{kg^{-1}.m^{-2}.s^{-1}}]$.
l=Params(1);
m=Params(2);
delta=Params(3);
g=9.81;
switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes;
  case 1
    sys = mdlDerivatives(t,x,u,l,m,delta,g); % Calculate derivatives
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
x0  = [0.1;0];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u,l,m,delta,g)
%\ddot{\theta}+\frac{\delta}{m\ell^2} \dot \theta +\frac{g}{\ell}\sin(\theta)=\frac{u}{m\ell^2}. 
sys(1) = x(2);
sys(2) = -delta/(m*l*l)*x(2)-g/l*sin(x(1))+u/(m*l*l);

function sys = mdlOutputs(t,x,u)
sys=x;
