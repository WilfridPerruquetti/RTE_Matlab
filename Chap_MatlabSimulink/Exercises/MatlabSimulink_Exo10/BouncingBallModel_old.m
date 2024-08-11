function [sys,x0,str,ts] = BouncingBallModel(t,x,u,flag,Params)
switch flag
    case 0
        % Initialization
        [sys, x0, str, ts] = mdlInitializeSizes();
    case 1
        % Derivatives
        sys = mdlDerivatives(t, x, u, Params);
    case 3
        % Outputs
        sys = mdlOutputs(t, x, u);
    case {2, 4, 9}
    sys = [];       % Unused flags
    otherwise
        % Unhandled flag
        error(['Unhandled flag = ', num2str(flag)]);
end

% Initialization
function [sys,x0,str,ts] = mdlInitializeSizes()
    sizes = simsizes;
    sizes.NumContStates  = 2;
    sizes.NumDiscStates  = 0;
    sizes.NumOutputs     = 2;
    sizes.NumInputs      = 1;
    sizes.DirFeedthrough = 0;
    sizes.NumSampleTimes = 1;

    sys = simsizes(sizes);
    x0  = [10; 0]; % Initial conditions: height 10m, velocity 0m/s
    str = [];
    ts  = [0 0];

% Derivatives
function sys = mdlDerivatives(t,x,u,Params)
    g=Params(1);
    e=Params(2);
    y = x(1);
    v = x(2);
    if y <= 0 && v < 0
        v = e * abs(v);
    end
    dy = v;
    dv = -g;
    sys = [dy; dv];

% Outputs
function sys = mdlOutputs(t, x, u)
    sys = [x(1); x(2)];
