function [sys,x0,str,ts] = ThreeTanks(t,x,u,flag,Params)
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
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0.1;0.2;0.3];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u,Params)
S1=Params(1);S2=Params(2);S3=Params(3);
a1=Params(4);a2=Params(5);a3=Params(6);

% S_{1}\dot{h}_{1}  &  =q_{1}-a_{1} \pui{h_{1}-h_{3}}{\frac{1}{2}},\\
% S_{2}\dot{h}_{2}  &  =q_{2}-a_{2} \pui{h_{2}-h_{3}}{\frac{1}{2}} \\
% S_{3}\dot{h}_{3}  & =a_{1}\pui{h_{1}-h_{3}}{\frac{1}{2}} +a_2 \pui{h_{2}-h_{3}}{\frac{1}{2}}.
q1=u(1);q2=u(2);
powabs=@(x,alpha)(sign(x)*abs(x).^alpha);
sys(1) = (q1-a1*powabs(x(1)-x(3),0.5))/S1;
sys(2) = (q2-a2*powabs(x(2)-x(3),0.5))/S2; 
sys(3) = (a1*powabs(x(1)-x(3),0.5)+a2*powabs(x(2)-x(3),0.5))/S3;

function sys = mdlOutputs(t,x,u)
sys=x;
