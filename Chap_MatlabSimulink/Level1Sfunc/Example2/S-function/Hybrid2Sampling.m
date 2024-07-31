function [sys,x0,str,ts] = Hybrid2Sampling(t,x,u,flag)
% Set the sampling period and offset
% first sampling
dperiod1 = 0.5;
doffset1 = 0;
% second sampling
dperiod2 = 0.25;
doffset2 = 0.1;
switch flag,
  case 0         
    [sys,x0,str,ts] = mdlInitializeSizes(dperiod1,doffset1,dperiod2,doffset2); % Initialization
  case 1
    sys = mdlDerivatives(t,x,u); % Calculate derivatives
  case 2
    sys = mdlUpdate(t,x,u,dperiod1,doffset1,dperiod2,doffset2); % Update disc. states
  case 3
    sys = mdlOutputs(x); % Calculate outputs
  case {4, 9}
    sys = [];       % Unused flags
  otherwise
    error(['unhandled flag = ',num2str(flag)]); % Error handling
end

function [sys,x0,str,ts] = mdlInitializeSizes(dperiod1,doffset1,dperiod2,doffset2)
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 4;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 3;
sys = simsizes(sizes);
x0  = [1;2;1;-2;0.5;0.8]; % Initial conditions: cont. state + disc. state
str = [];
ts  = [0,       0         % continuous time
       dperiod1, doffset1 % sample time 1
       dperiod2, doffset2]; % sample time 2

function sys = mdlDerivatives(t,x,u)
sys(1) = x(2)+30*sin(t)*x(3)+10*cos(10*t)*x(5);
sys(2) = -100*x(1)-14*x(2)-x(1)*x(2)+x(6)+10*u; 

function sys = mdlUpdate(t,x,u,dperiod1,doffset1,dperiod2,doffset2)
% Return next discrete state if we have a sample hit within a 
% tolerance of 1e-8. If we don't have a sample hit, the discrete state shouldn't change.

% keep same values for discrete state except if sample hit
sys(1) = x(3); 
sys(2) = x(4);
sys(3) = x(5); 
sys(4) = x(6);

% change discrete state
if abs(round((t-doffset1)/dperiod1)-(t-doffset1)/dperiod1) < 1e-8
  sys(1) = x(4); 
  sys(2) = 0.2*x(4)+0.1*x(5)+0.1*x(3)*sin(t)+0.1*x(6);
end
if abs(round((t-doffset2)/dperiod2)-(t-doffset2)/dperiod2) < 1e-8
  sys(3) = x(6); 
  sys(4) = 0.1*x(5)+0.5*x(6)+0.1*x(3)*sin(t)+0.1*x(4);
end

function sys = mdlOutputs(x)
  sys = x;
