function [sys, x0, str, ts] = discrete_integrator(t, x, u, flag)
switch flag
case 0 % Initialization
[sys, x0, str, ts] = mdlInitializeSizes();
case 2 % Update
sys = mdlUpdate(t, x, u);
case 3 % Outputs
sys = mdlOutputs(t, x, u);
otherwise
sys = [];
end
end

function [sys, x0, str, ts] = mdlInitializeSizes()
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 1; % One discrete state
sizes.NumOutputs     = 1;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0; % No direct feedthrough
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);

x0  = 0; % Initial state
str = [];
ts  = [0.2 0]; % Discrete sample time with a period of 0.2 seconds
end

function sys = mdlUpdate(t, x, u)
sys = x + u; % Accumulate input
end

function sys = mdlOutputs(t, x, u)
sys = x; % Output the accumulated value
end