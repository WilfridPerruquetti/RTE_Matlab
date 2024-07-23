function [sys,x0,str,ts] = StepperMotor(t,x,u,flag,Params)
m=Params(1);
J=Params(2);
g=9.81;
switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes;
  case 1
    sys = mdlDerivatives(t,x,u,m,J,g); % Calculate derivatives
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
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0.1;0;-0.1;0];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u,m,J,g)
%\dot x_1&=& x_2,\\
%\dot x_2&=& -g\sin (x_3 )+x_1x_3^{2}\\
%\dot x_3&=& x_4,\\
%\dot x_4&=& \frac{1}{(mx_1^{2}+J)} \left( u-2m x_1x_2x_4-mgx_1\cos (x_3 )\right),
sys(1,1) = x(2);
sys(2,1) = -g*sin(x(3))+x(1)*x(3)*x(3);
sys(3,1) = x(4);
sys(4,1) = (u(1)-2*m*x(1)*x(2)*x(4)-m*g*x(1)*cos(x(3)))/(m*x(1)*x(1)+J);

function sys = mdlOutputs(t,x,u)
for i=1:4
  sys(i,1) = x(i); 
end;
