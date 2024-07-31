function [sys,x0,str,ts] = Hybrid(t,x,u,flag,dperiod,doffset)
% Set the sampling period and offset

switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes(dperiod,doffset);
  case 1
    sys = mdlDerivatives(t,x,u); % Calculate derivatives
  case 2
    sys = mdlUpdate(t,x,u,dperiod,doffset); % Update disc states
  case 3
    sys = mdlOutputs(x); % Calculate outputs
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
sizes.NumDiscStates  = 3;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 2;
sys = simsizes(sizes);
x0  = [1;1;0;1;-2];
str = [];
ts  = [0,       0           % sample time
       dperiod, doffset];
% End of mdlInitializeSizes.

%==============================================================
% mdlDerivatives
% Compute derivatives for continuous states.
%==============================================================
function sys = mdlDerivatives(t,x,u)
sys(1) = x(2);
sys(2) = -100*x(1)-14*x(2)-x(1)*x(2)+sin(t)*x(3)+u; 
% End of mdlDerivatives.

%==============================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time 
% step requirements.
%==============================================================
function sys = mdlUpdate(t,x,u,dperiod,doffset)
%y[n]−0.3y[n−1]+0.4y[n−2]=0.5u[n]+0.25u[n−1]
if t==0 sys = []; 
elseif abs(round((t-doffset)/dperiod)-(t-doffset)/dperiod) < 1e-8
    u_nMinus1=x(1);
    y_nMinus2=x(2);
    y_nMinus1=x(3);
    y_n=0.3*y_nMinus1+0.4*y_nMinus2+0.5*u+0.25*u_nMinus1;
    sys(1) = u; 
    sys(2) = y_nMinus1;
    sys(3) = y_n;
else
  sys = [];   % This is not a sample hit, so return an empty 
end           % matrix to indicate that the states have not 
              % changed.
% End of mdlUpdate.

%==============================================================
% mdlOutputs
% Return the output vector for the S-function.
%==============================================================
function sys = mdlOutputs(x)
  sys = x;
