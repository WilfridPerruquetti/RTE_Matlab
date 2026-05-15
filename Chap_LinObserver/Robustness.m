% Nominal system and observer design
A = [0 1; -2 -3]; C = [1 0];
poles_obs = [-5, -6];
L = place(A', C', poles_obs)';

% Generate 100 random perturbations (10% uncertainty)
n_trials = 100;
delta_max = 0.1; % 10% uncertainty
lambda_min = zeros(n_trials, 1);

for k = 1:n_trials
    % Random perturbation
    Delta_A = delta_max * randn(size(A));
    A_pert = A + Delta_A;
    % Eigenvalues of A - LC under perturbation
    eigs = eig(A_pert - L*C);
    lambda_min(k) = min(real(eigs)); % Distance to RHP
end

% ==========================================
% --- Robustness summary (CORRECTED DISPLAY)
% ==========================================
disp('--------- ROBUSTNESS SUMMARY ---------');

disp('Matrix A:');
disp(A);

disp('Observer Gain L:');
disp(L);

disp('Closed-Loop Eigenvalues (nominal):');
disp(eig(A - L*C));

disp('--------------------------------------');
% Utilisation de %.4f pour limiter à 4 décimales et rendre la lecture plus agréable
fprintf('Min eigenvalue (nominal)            : %.4f\n', min(real(eig(A - L*C))));
fprintf('Min eigenvalue (worst case, 10%% unc): %.4f\n', min(lambda_min));
fprintf('Robustness margin                   : %.4f\n', min(lambda_min) / min(real(eig(A - L*C))));
disp('--------------------------------------');