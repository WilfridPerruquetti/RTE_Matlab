function [sys,x0,str,ts] = VolterraLotka(t,x,u,flag,Params)
a=Params(1);b=Params(2);c=Params(3);d=Params(4);
switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes;
  case 1
    sys = mdlDerivatives(t,x,u,a,b,c,d); % Calculate derivatives
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
x0  = [1;1.5];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u,a,b,c,d)
%\frac{\mathrm {d} x}{\mathrm {d} t}(t)=\alpha x(t)-\gamma x(t)y(t)\text{\quad (herbivorous),} \\
%\frac{\mathrm {d} y}{\mathrm {d} t}(t)=-\beta y(t)+\delta x(t)y(t)\text{\quad (carnivorous),}
sys(1) = a*x(1)-c*x(1)*x(2);
sys(2) = -b*x(2)+d*x(1)*x(2);

function sys = mdlOutputs(t,x,u)
sys=x;
