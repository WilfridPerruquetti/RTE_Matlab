function [sys, x0, str, ts] = simple_gain(t, x, u, flag)
switch flag
case 0 % Initialization
[sys, x0, str, ts] = mdlInitializeSizes();
case 3 % Outputs
sys = mdlOutputs(t, x, u);
otherwise
sys = [];
end
% end

function [sys, x0, str, ts] = mdlInitializeSizes()
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);

x0  = [];
str = [];
ts  = [0 0]; % Continuous time
% end mdlInitializeSizes

function sys = mdlOutputs(t, x, u)
gain = 2; % Example gain
sys = gain * u;
% end mdlOutputs