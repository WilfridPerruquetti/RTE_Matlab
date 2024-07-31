function [sys, x0, str, ts] = sfun1(t, x, u, flag)
% S-Function example sfun1.m
% This S-Function has no states and performs the algebraic function y = u(1) + u(2)^2.
% There are two inputs and one output.

switch flag
case 0
% Initialization
[sys, x0, str, ts] = mdlInitializeSizes;
case 3
% Compute outputs
sys = mdlOutputs(t, x, u);
case {1,2,4,9}
sys = [];
otherwise
% Invalid flag
error('Unhandled flag = %d', flag);
end

function [sys, x0, str, ts] = mdlInitializeSizes()
% Return the sizes of the system vectors, initial conditions, and sample times.
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 2;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0 = []; % Initial conditions
str = []; % Str is always an empty matrix
ts  = [0 0]; % Sample continuous time

function sys = mdlOutputs(t, x, u)
% Compute output vector
sys = sin(u(1))+ u(2)^2;
