function [sys,x0,str,ts] = BouncingBallModel(t,x,u,flag)
    % Bouncing Ball Parameters
    g = 9.81;   % Acceleration due to gravity (m/s^2)
    e = 0.8;    % Coefficient of restitution

    switch flag,
        case 0, % Initialization
            [sys, x0, str, ts] = mdlInitializeSizes;

        case 1, % Derivatives
            sys = mdlDerivatives(t, x, u, g, e);

        case 2, % Update
            sys = mdlUpdate(t, x, u);

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

% Initialization
function [sys, x0, str, ts] = mdlInitializeSizes
    sizes = simsizes;
    sizes.NumContStates  = 2;
    sizes.NumDiscStates  = 1;
    sizes.NumOutputs     = 3;
    sizes.NumInputs      = 1;
    sizes.DirFeedthrough = 0;
    sizes.NumSampleTimes = 1;

    sys = simsizes(sizes);
    % Initial conditions: 
    % height 10m, 
    % velocity 0m/s 
    % the last component is the Initial discrete state (not bounced)
    x0  = [10; 0; 0];
    str = [];
    ts  = [0 0];
    %simStateCompliance = 'UnknownSimState';

% Derivatives
function sys = mdlDerivatives(t, x, u, g, e)
    v = x(2);
    bounceDetected = x(3);
    if bounceDetected==1
        v = e * abs(v);      % Update velocity after impact
    else
        v = v;
    end;

    while x(1)<=0
        v=1;
    end

    
    dy = v;
    dv = -g;
    sys = [dy; dv];

% Update
function sys = mdlUpdate(t, x, u)
    y = x(1);
    v = x(2);
    bounceDetected = x(3);
    % Detect bounce
    if y <=0 && v < 0 && bounceDetected == 0  % Collision occurs and not already bounced
        sys = 1;      % Set discrete state to indicate bounce detected
    else
        sys = 0;      % Reset discrete state when above ground
    end   

% Outputs
function sys = mdlOutputs(t, x, u)
    sys = [x(1); x(2);x(3)];

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




