clear; clc;

% Illustrative Ball-and-Beam parameters
m = 0.11;
J = 0.02;
g = 9.81;

A = [0 1 0 0;
     0 0 -g 0;
     0 0 0 1;
     -m*g/J 0 0 0];
B = [0; 0; 0; 1/J];
C = [1 0 0 0];

Q = diag([20 10 30 10]);
R = 5;

% Luenberger gains
polesSlow = [-2 -2.5 -3 -3.5];
polesMed  = [-5 -6 -7 -8];
polesFast = [-15 -16 -17 -18];
Lslow = place(A',C',polesSlow)';
Lmed  = place(A',C',polesMed)';
Lfast = place(A',C',polesFast)';

% Steady-state Kalman gain
[Pss,~,Lkal] = care(A',C',Q,R);
Lkal = Lkal';

% Simulation parameters
Tend = 8;
dt = 1e-3;
t = 0:dt:Tend;

x = [0.08; 0; 0.03; 0];
xhatSlow = zeros(4,1);
xhatMed  = zeros(4,1);
xhatFast = zeros(4,1);
xhatKal  = zeros(4,1);

X  = zeros(4,length(t));
XS = zeros(4,length(t));
XM = zeros(4,length(t));
XF = zeros(4,length(t));
XK = zeros(4,length(t));

rng(0);
for k = 1:length(t)
    tk = t(k);
    u = 0.2*sin(2*tk);
    processNoise = chol(Q,'lower')*randn(4,1);
    measNoise = sqrt(R)*randn;
    y = C*x + measNoise;

    X(:,k)  = x;
    XS(:,k) = xhatSlow;
    XM(:,k) = xhatMed;
    XF(:,k) = xhatFast;
    XK(:,k) = xhatKal;

    if k < length(t)
        xdot = A*x + B*u + processNoise;
        xhatdotSlow = A*xhatSlow + B*u + Lslow*(y - C*xhatSlow);
        xhatdotMed  = A*xhatMed  + B*u + Lmed *(y - C*xhatMed);
        xhatdotFast = A*xhatFast + B*u + Lfast*(y - C*xhatFast);
        xhatdotKal  = A*xhatKal  + B*u + Lkal *(y - C*xhatKal);

        x = x + dt*xdot;
        xhatSlow = xhatSlow + dt*xhatdotSlow;
        xhatMed  = xhatMed  + dt*xhatdotMed;
        xhatFast = xhatFast + dt*xhatdotFast;
        xhatKal  = xhatKal  + dt*xhatdotKal;
    end
end

names = {'r','rdot','theta','thetadot'};
figure;
for i = 1:4
    subplot(2,2,i);
    plot(t,X(i,:),t,XS(i,:),'--',t,XM(i,:),'-.',t,XF(i,:),':',t,XK(i,:),'LineWidth',1.05);
    grid on;
    title(names{i});
    if i == 1
        legend('x','L slow','L med','L fast','Kalman');
    end
end
	