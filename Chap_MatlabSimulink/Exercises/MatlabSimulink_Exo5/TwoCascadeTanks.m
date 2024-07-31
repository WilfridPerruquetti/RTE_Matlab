function [sys,x0,str,ts] = TwoCascadeTanks(t,x,u,flag,Params)
switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes;
  case 1
    sys = mdlDerivatives(t,x,u,Params); % Calculate derivatives
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
x0  = [0.4;0.5];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u,Params)
%S= 0.3512 \, [\unit{m^2}], \alpha_1= \alpha_2=0.0443$
S=Params(1);
a1=Params(2);
a2=Params(3);
% \dot{x}_{1}=\frac{1}{S} \left(u-\alpha_{1}\sqrt{x_{1}}\right)\\
% \dot{x}_{2}=\frac{1}{S}(\alpha_{1}\sqrt{x_{1}}-\alpha_{2}\sqrt{x_{2}}),\\
sys(1) = (u-a1*sqrt(x(1)))/S;
sys(2) = (a1*sqrt(x(1))-a2*sqrt(x(2)))/S;

function sys = mdlOutputs(t,x,u)
sys=x;
