function [sys,x0,str,ts,simStateCompliance] = BouncingBallModel(t,x,u,flag,Params)
    % Bouncing Ball Parameters
    g = 9.81;   % Acceleration due to gravity (m/s^2)
    e = 0.8;    % Coefficient of restitution

    switch flag,
        case 0, % Initialization
            [sys, x0, str, ts, simStateCompliance] = mdlInitializeSizes;

        case 1, % Derivatives
            sys = mdlDerivatives(t, x, u, g,e);

        % case 2, % Update
        %     sys = mdlUpdate(t, x, u, e);

        case 3, % Outputs
            sys = mdlOutputs(t, x, u);

        % case 4, % GetTimeOfNextVarHit
        %     sys = mdlGetTimeOfNextVarHit(t, x, u);

        % case 9, % ZeroCrossings
        %     sys = mdlZeroCrossings(t, x, u);

        case {2, 4, 9} % Unused flags
            sys = [];

        otherwise
            error(['Unhandled flag = ', num2str(flag)]);
    end
end

% Initialization
function [sys, x0, str, ts, simStateCompliance] = mdlInitializeSizes
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
    simStateCompliance = 'UnknownSimState';
end

% Derivatives
function sys = mdlDerivatives(t, x, u, g,e)
    y = x(1);
    v = x(2);
    if abs(y) <= 1e-2 && v < 0
        v = -e * abs(v);
    end
    dy = v;
    dv = -g;
    sys = [dy; dv];
end

% Update
% function sys = mdlUpdate(t, x, u, e)
%     y = x(1);
%     v = x(2);
%     if abs(y) <= 1e-3 && v < 0
%         v = -e * abs(v);
%     end
%     sys = v;
% end

% Outputs
function sys = mdlOutputs(t, x, u)
    sys = [x(1); x(2)];
end

% % GetTimeOfNextVarHit
% function sys = mdlGetTimeOfNextVarHit(t, x, u)
%     sampleTime = 0.1; % Set the sample time
%     sys = t + sampleTime;
% end

% % ZeroCrossings
% function sys = mdlZeroCrossings(t, x, u)
%     y = x(1);
%     sys = y;
% end
