set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

a1 = 0.6; a2 = 0.4; b = 1;
A = [-a1 0; a1 -a2]; B = [b; 0]; C = [0 1];

Q_A = 0.01*eye(2); R_A = 0.001;
Q_B = 0.10*eye(2); R_B = 0.100;

[P_A,~,L_A] = care(A',C',Q_A,R_A); L_A = L_A';
[P_B,~,L_B] = care(A',C',Q_B,R_B); L_B = L_B';

fprintf('Low-noise gain  L_A = [%g %g]^T\n',L_A);
fprintf('High-noise gain L_B = [%g %g]^T\n',L_B);

dt = 0.01; t = 0:dt:40; rng(1);
u = ones(size(t)); noise = sqrt(R_B/dt)*randn(size(t));
x = [0;0]; xhatA = [0.2;-0.1]; xhatB = xhatA;
errA = zeros(2,numel(t)); errB = errA;
for k = 1:numel(t)
    y = C*x + noise(k);
    xdot = A*x + B*u(k);
    xhatA_dot = A*xhatA + B*u(k) + L_A*(y - C*xhatA);
    xhatB_dot = A*xhatB + B*u(k) + L_B*(y - C*xhatB);
    x = x + dt*xdot; xhatA = xhatA + dt*xhatA_dot;
    xhatB = xhatB + dt*xhatB_dot;
    errA(:,k) = x - xhatA; errB(:,k) = x - xhatB;
end
figure; plot(t,vecnorm(errA),t,vecnorm(errB),'LineWidth',1.2);
legend('Low-noise tuning','High-noise tuning'); grid on;
xlabel('Time (s)'); ylabel('Estimation-error norm');

exportgraphics(gcf, 'FigureNoiseKalmanComp.pdf', 'ContentType', 'vector');