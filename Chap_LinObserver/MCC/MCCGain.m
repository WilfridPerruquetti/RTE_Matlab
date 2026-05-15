% System parameters
tau = 0.1;
k_p = 2.5;

% State-space matrices
A = [0 1; 0 -1/tau];
B = [0; k_p/tau];
C = [1 0];

% Observer pole placement
poles_obs = [-30, -40];
L = place(A', C', poles_obs)';

fprintf('Observer gain L = \n');
disp(L);

% Verify stability of A - LC
eigs_cl = eig(A - L*C);
fprintf('Closed-loop eigenvalues: %f, %f\n', eigs_cl(1), eigs_cl(2));