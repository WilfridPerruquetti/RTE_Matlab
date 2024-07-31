function [sys,x0,str,ts] = Hybrid(t,x,u,flag)
dperiod = 0.5; % Sampling period
doffset = 0; % offset
switch flag,
  case 0         
    [sys,x0,str,ts] = mdlInitializeSizes(dperiod,doffset); % Initialization
  case 1
    sys = mdlDerivatives(t,x,u); % Calculate derivatives
  case 2
    sys = mdlUpdate(t,x,u,dperiod,doffset); % Update disc states
  case 3
    sys = mdlOutputs(t,x,u,dperiod,doffset); % Calculate outputs
  case {4, 9}
    sys = [];       % Unused flags
  otherwise
    error(['unhandled flag = ',num2str(flag)]); % Error handling
end

function [sys,x0,str,ts] = mdlInitializeSizes(dperiod,doffset)
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 2;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 2;
sys = simsizes(sizes);
x0  = [0.1;0.2;1;-2]; % intial continuous state + discrete state
str = [];
ts  = [0,       0         % continuous
       dperiod, doffset]; % sample time

function sys = mdlDerivatives(t,x,u)
sys(1) = x(2);
sys(2) = -100*x(1)-14*x(2)-x(1)*x(2)+sin(t)*x(3)+u; 

function sys = mdlUpdate(t,x,u,dperiod,doffset)
% Return next discrete state if we have a sample hit within a 
% tolerance of 1e-8. If we don't have a sample hit, return [] to
% indicate that the discrete state shouldn't change.
if t==0 sys = []; 
elseif abs(round((t-doffset)/dperiod)-(t-doffset)/dperiod) < 1e-8
  sys(1) = x(4); 
  sys(2) = x(4)+0.01*x(3)*sin(t);
else
  sys = [];   % This is not a sample hit, so return an empty 
end           % matrix to indicate that the states have not 
              % changed.

function sys = mdlOutputs(t,x,u,dperiod,doffset)
  sys = x;
