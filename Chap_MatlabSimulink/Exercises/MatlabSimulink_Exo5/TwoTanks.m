function [sys,x0,str,ts] = TwoTanks(t,x,u,flag,Params)
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
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0.1;0.2];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u,Params)
% S_1=1\, [\unit{m^2}], S_2=0.5\, [\unit{m^2}],  a_1=0.443,a_2=0.886$.
S1=Params(1);S2=Params(2);a1=Params(3);a2=Params(4);
%S_{1}\dot{h}_{1}  & = & q_{e1}-a_{1}\operatorname{sign}(h_{1}-h_{2})\sqrt{\left\vert h_{1}-h_{2}\right\vert }, \label{eq:TwoInterConnectTank1}\\
%S_{2}\dot{h}_{2}  & = & q_{e2}+a_{1}\operatorname{sign}(h_{1}-h_{2})\sqrt{\left\vert h_{1}-h_{2}\right\vert}-a_{2}\sqrt{h_{2}}.\label{eq:TwoInterConnectTank2}
q1=u(1);q2=u(2);
powabs=@(x,alpha)(sign(x)*abs(x).^alpha);
sys(1) = (q1-a1*powabs(x(1)-x(2),0.5))/S1;
sys(2) = (q2+a1*powabs(x(1)-x(2),0.5)-a2*sqrt(x(2)))/S2;

function sys = mdlOutputs(t,x,u)
sys=x;
