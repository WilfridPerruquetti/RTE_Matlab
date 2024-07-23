function [sys,x0,str,ts] = Hybrid(t,x,u,flag)
% Set the sampling period and offset
dperiod = 0.5;
doffset = 0;
switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes(dperiod,doffset);
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
% End 

%==============================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the 
% S-function.
%==============================================================
function [sys,x0,str,ts] = mdlInitializeSizes(dperiod,doffset)
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 2;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 2;
sys = simsizes(sizes);
x0  = [0.1;0.2;1;-2]; % two first concern continuous state and the two last ones concern discrete state
str = [];
ts  = [0,       0           % sample time
       dperiod, doffset];
% End of mdlInitializeSizes.

%==============================================================
% mdlDerivatives
% Compute derivatives for continuous states.
%==============================================================
function sys = mdlDerivatives(t,x,u)
sys(1,1) = x(2);
sys(2,1) = -100*x(1)-14*x(2)-x(1)*x(2)+sin(t)*x(3)+u; 
% End of mdlDerivatives.

%==============================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time 
% step requirements.
%==============================================================
function sys = mdlUpdate(t,x,u,dperiod,doffset)
% Return next discrete state if we have a sample hit within a 
% tolerance of 1e-8. If we don't have a sample hit, return [] to
% indicate that the discrete state shouldn't change.
if t==0 sys = []; 
elseif abs(round((t-doffset)/dperiod)-(t-doffset)/dperiod) < 1e-8
  sys(1,1) = x(4); 
  sys(2,1) = x(4)+0.1*x(3)*sin(t);
else
  sys = [];   % This is not a sample hit, so return an empty 
end           % matrix to indicate that the states have not 
              % changed.
% End of mdlUpdate.

%==============================================================
% mdlOutputs
% Return the output vector for the S-function.
%==============================================================
function sys = mdlOutputs(t,x,u,dperiod,doffset)
% Return output
% two first outputs are the continuous states and the two last the discrete
% states
  sys(1,1) = x(1); 
  sys(2,1) = x(2);
  sys(3,1) = x(3);
  sys(4,1) = x(4);
% End of mdlOutputs.