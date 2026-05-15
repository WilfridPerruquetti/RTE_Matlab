% =========================================================================
% Ball-and-Beam: Observer Comparison (Luenberger vs Kalman)
% Scenarios: Open-Loop (Instability) & Closed-Loop (LQR Stabilization)
% =========================================================================
clear; clc; close all;

set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% --- 1. Ball-and-Beam Parameters ---
m = 0.11;   % Mass of the ball
J = 0.02;   % Inertia
g = 9.81;   % Gravity
% State: [position (r), velocity (rdot), angle (theta), angular_vel (thetadot)]
A = [0 1 0 0;
     0 0 -g 0;
     0 0 0 1;
     -m*g/J 0 0 0];
B = [0; 0; 0; 1/J];
C = [1 0 0 0]; % We only measure position (r)

% --- 2. Observer Design ---
% Luenberger poles
polesSlow = [-2 -2.2 -2.4 -2.6];
polesMed  = [-5 -6 -7 -8];
polesFast = [-15 -16 -17 -18];

Lslow = place(A', C', polesSlow)';
Lmed  = place(A', C', polesMed)';
Lfast = place(A', C', polesFast)';

% Kalman Filter Design (Realistic Noise)
Q = diag([1e-6 1e-7 1e-6 1e-7]); % Process noise covariance
R = 1e-4;                        % Measurement noise covariance
[~,~,Lkal] = care(A', C', Q, R);
Lkal = Lkal';

% --- 3. Controller Design (LQR for Closed-Loop) ---
Q_lqr = diag([100 1 100 1]);
R_lqr = 0.01;
K = lqr(A, B, Q_lqr, R_lqr);

% --- 4. Simulation Parameters ---
Tend = 1.5; % 1.5 seconds to observe convergence before OL divergence
dt = 1e-3;
t = 0:dt:Tend;
N = length(t);

% Run two scenarios: Open-Loop (OL) and Closed-Loop (CL)
for scenario = 1:2
    % Initial conditions
    x = [0.08; 0; 0.03; 0]; % Plant starts with an offset
    xhatS = zeros(4,1); xhatM = zeros(4,1); 
    xhatF = zeros(4,1); xhatK = zeros(4,1);
    
    % Data storage
    X_hist = zeros(4, N); XS_hist = zeros(4, N); XM_hist = zeros(4, N);
    XF_hist = zeros(4, N); XK_hist = zeros(4, N); U_hist = zeros(1, N);

    for k = 1:N
        % Select Control Law
        if scenario == 1 % Open-Loop
            u = 0.1 * sin(t(k)); 
            title_str = 'Scenario 1: Open-Loop (Unstable)';
        else % Closed-Loop
            u = -K * xhatK + 0.1 * sin(t(k)); % Stabilize using Kalman estimate
            title_str = 'Scenario 2: Closed-Loop (Stabilized by LQR)';
        end

        % Noises
        processNoise = chol(Q,'lower') * randn(4,1);
        measNoise = sqrt(R) * randn;
        y = C*x + measNoise;

        % Save History
        X_hist(:,k)  = x;
        XS_hist(:,k) = xhatS;
        XM_hist(:,k) = xhatM;
        XF_hist(:,k) = xhatF;
        XK_hist(:,k) = xhatK;
        U_hist(k)    = u;

        % Integration (Euler)
        dx = A*x + B*u + processNoise;
        xhatdotS = A*xhatS + B*u + Lslow*(y - C*xhatS);
        xhatdotM = A*xhatM + B*u + Lmed *(y - C*xhatM);
        xhatdotF = A*xhatF + B*u + Lfast*(y - C*xhatF);
        xhatdotK = A*xhatK + B*u + Lkal *(y - C*xhatK);

        x = x + dt*dx;
        xhatS = xhatS + dt*xhatdotS;
        xhatM = xhatM + dt*xhatdotM;
        xhatF = xhatF + dt*xhatdotF;
        xhatK = xhatK + dt*xhatdotK;
    end

    % --- Plotting ---
    fig = figure('Name', title_str, 'Color', 'w', 'Position', [100, 100, 900, 700]);
    names = {'Position $r$ (m)', 'Velocity $\dot{r}$ (m/s)', ...
             'Angle $\theta$ (rad)', 'Ang. Velocity $\dot{\theta}$ (rad/s)'};
             
    for i = 1:4
        subplot(2,2,i);
        plot(t, X_hist(i,:), 'k', 'LineWidth', 1.5, 'DisplayName', 'True state'); hold on;
        plot(t, XS_hist(i,:), '--', 'DisplayName', 'L Slow');
        plot(t, XM_hist(i,:), '-.', 'DisplayName', 'L Med');
        plot(t, XF_hist(i,:), ':', 'DisplayName', 'L Fast');
        plot(t, XK_hist(i,:), 'Color', [0 0.5 0], 'LineWidth', 1.2, 'DisplayName', 'Kalman'); % Vert pour distinguer
        grid on; ylabel(names{i}); xlabel('Time (s)');
        if i == 1, legend('Location', 'best', 'FontSize', 8); title(title_str); end
    end

    % --- Exportation dynamique ---
    if scenario == 1
        exportgraphics(fig, 'FigureBallBeam_OpenLoop.pdf', 'ContentType', 'vector');
    else
        exportgraphics(fig, 'FigureBallBeam_ClosedLoop.pdf', 'ContentType', 'vector');
    end
end