clear; clc; close all;

% Set default interpreters to LaTeX
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% System matrices
A = [0 1; -2 -3];
B = [0; 1];
C = [1 0];

% Controller and Observer gains
K = place(A, B, [-2 -3]);
L = place(A', C', [-6 -7])';

% Augmented system matrix (Closed-loop)
Acl = [A-B*K,  B*K;
       zeros(2), A-L*C];

% Verify eigenvalues
disp('Closed-loop eigenvalues:');
disp(eig(Acl));

% --- Simulation Parameters ---
tspan = 0:0.01:5;
x0 = [1; 0.5];          % Initial real state
e0 = [0.2; -0.1];       % Initial estimation error
initial_conditions = [x0; e0];

% --- Augmented System Simulation ---
% Dynamics: [x_dot; e_dot] = Acl * [x; e]
sys_cl = ss(Acl, zeros(4,1), eye(4), zeros(4,1));
[~, t, states] = initial(sys_cl, initial_conditions, tspan);

% --- Plotting Results ---
figure('Position', [100, 100, 800, 400]);

% Left Subplot: State vs Estimate
subplot(1,2,1);
plot(t, states(:,1), 'b', t, states(:,1)-states(:,3), 'r--', 'LineWidth', 1.5);
grid on; 
title('$\mathrm{State}\ x_1\ \mathrm{and\ its\ estimation}$', 'FontSize', 12);
legend({'$x_1$', '$\hat{x}_1$'}, 'Location', 'best'); 
xlabel('Time (s)');
ylabel('Amplitude');

% Right Subplot: Estimation Errors
subplot(1,2,2);
plot(t, states(:,3), 'k', t, states(:,4), 'k--', 'LineWidth', 1.5);
grid on; 
title('$\mathrm{Estimation\ errors}\ e_k$', 'FontSize', 12);
legend({'$e_1$', '$e_2$'}, 'Location', 'best'); 
xlabel('Time (s)');
ylabel('Error');

% Export for LaTeX
exportgraphics(gcf, 'FigureExampleSeparationPrinciple.pdf', 'ContentType', 'vector');