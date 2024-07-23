function [sys,x0,str,ts] = Hybrid2Sampling(t,x,u,flag)
% Set the sampling period and offset
% first sampling
dperiod1 = 0.5;
doffset1 = 0;

% second sampling
dperiod2 = 0.25;
doffset2 = 0.1;
switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes(dperiod1,doffset1,dperiod2,doffset2);
  case 1
    sys = mdlDerivatives(t,x,u); % Calculate derivatives
  case 2
    sys = mdlUpdate(t,x,u,dperiod1,doffset1,dperiod2,doffset2); % Update disc states
  case 3
    sys = mdlOutputs(t,x,u,dperiod1,doffset1,dperiod2,doffset2); % Calculate outputs
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
function [sys,x0,str,ts] = mdlInitializeSizes(dperiod1,doffset1,dperiod2,doffset2)
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 4;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 3;
sys = simsizes(sizes);
x0  = [1;2;1;-2;0.5;0.8]; % two first concern continuous state and the four last ones concern discrete state
str = [];
ts  = [0,       0           % sample time
       dperiod1, doffset1
       dperiod2, doffset2];
% End of mdlInitializeSizes.

%==============================================================
% mdlDerivatives
% Compute derivatives for continuous states.
%==============================================================
function sys = mdlDerivatives(t,x,u)
sys(1,1) = x(2)+30*sin(t)*x(3)+10*cos(10*t)*x(5);
sys(2,1) = -100*x(1)-14*x(2)-x(1)*x(2)+x(6)+10*u; 
% End of mdlDerivatives.

%==============================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time 
% step requirements.
%==============================================================
function sys = mdlUpdate(t,x,u,dperiod1,doffset1,dperiod2,doffset2)
% Return next discrete state if we have a sample hit within a 
% tolerance of 1e-8. If we don't have a sample hit, the discrete state shouldn't change.

% keep same values for discrete state except if sample hit
sys(1,1) = x(3); 
sys(2,1) = x(4);
sys(3,1) = x(5); 
sys(4,1) = x(6);

% change discrete state
if abs(round((t-doffset1)/dperiod1)-(t-doffset1)/dperiod1) < 1e-8
  sys(1,1) = x(4); 
  sys(2,1) = 0.2*x(4)+0.1*x(5)+0.1*x(3)*sin(t)+0.1*x(6);
end
if abs(round((t-doffset2)/dperiod2)-(t-doffset2)/dperiod2) < 1e-8
  sys(3,1) = x(6); 
  sys(4,1) = 0.1*x(5)+0.5*x(6)+0.1*x(3)*sin(t)+0.1*x(4);
end
% End of mdlUpdate.

%==============================================================
% mdlOutputs
% Return the output vector for the S-function.
%==============================================================
function sys = mdlOutputs(t,x,u,dperiod1,doffset1,dperiod2,doffset2)
% Return output
% two first outputs are the continuous states and the two last the discrete
% states
  sys(1,1) = x(1); 
  sys(2,1) = x(2);
  sys(3,1) = x(3);
  sys(4,1) = x(4);
  sys(5,1) = x(5);
  sys(6,1) = x(6);
% End of mdlOutputs.