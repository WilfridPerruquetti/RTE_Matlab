function [sys,x0,str,ts] = Discrete(t,x,u,flag,dperiod,doffset)

switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes(dperiod,doffset);
  case 2
    sys = mdlUpdate(t,x,u,dperiod,doffset); % Update disc states
  case 3
    sys = mdlOutputs(x); % Calculate outputs
  case {1, 4, 9}
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
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 3;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0;1;-2]; % the first one for u and the two other for y
str = [];
ts  = [dperiod, doffset];
% End of mdlInitializeSizes.

%==============================================================
% mdlUpdate
% Handle discrete state updates.
%==============================================================
function sys = mdlUpdate(t,x,u,dperiod,doffset)
%y[n]−0.3y[n−1]+0.4y[n−2]=0.5u[n]+0.25u[n−1]
    u_nMinus1=x(1);
    y_nMinus2=x(2);
    y_nMinus1=x(3);
    y_n=0.3*y_nMinus1+0.4*y_nMinus2+0.5*u+0.25*u_nMinus1;
    sys(1) = u; 
    sys(2) = y_nMinus1;
    sys(3) = y_n;
% End of mdlUpdate.

%==============================================================
% mdlOutputs
% Return the output vector for the S-function.
%==============================================================
function sys = mdlOutputs(x)
% Return states
  sys = x;
% End of mdlOutputs.