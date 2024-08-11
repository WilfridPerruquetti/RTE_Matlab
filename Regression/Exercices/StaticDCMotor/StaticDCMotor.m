clc;
clear all;
close all;
% load data
load("StaticDCMotorData.mat");
% Data from the table
v_a = [1, 8, 12, 20, 3, 10, 11, 25, 3, 3]';
Gamma_l = [0, 2, 3, 7.5, 0, 1, 3, 9, 0.1, 0]';
omega_m = [1.29, 4.24, 6.12, 2.18, 4.52, 9.20, 5.09, 3.58, 4.05, 3.87]';
	
% Construct the matrix X
X = [v_a, -Gamma_l];
	
% Least squares estimate for a0 and a1
a_hat = (X' * X) \ (X' * omega_m);
	
% Predicted omega_m
omega_m_hat = X * a_hat;
	
% Residuals
residuals = omega_m - omega_m_hat;
	
% Mean Squared Error (MSE)
MSE = mean(residuals.^2);
	
% Observed Residual Variance
observed_residual_variance = var(residuals);
	
% Coefficient of Determination R^2
R2 = 1 - sum(residuals.^2) / sum((omega_m - mean(omega_m)).^2);
	
% Display the results
fprintf('Estimated a0: %.4f\n', a_hat(1));
fprintf('Estimated a1: %.4f\n', a_hat(2));
fprintf('Mean Squared Error (MSE): %.4f\n', MSE);
fprintf('Observed Residual Variance: %.4f\n', observed_residual_variance);
fprintf('R^2: %.4f\n', R2);

% alternate solution using fitlm
tbl=table(v_a,-Gamma_l,omega_m,'VariableNames',{'voltage','Optorque','speed'});
lm = fitlm(tbl,'speed~voltage+Optorque')

% Estimation of angular velocity for given v_a and Gamma_l
v_a_new = 19;
Gamma_l_new = 7.5;
omega_m_new = a_hat(1) * v_a_new - a_hat(2) * Gamma_l_new;
	
fprintf('Estimated angular velocity for v_a = 19V and Gamma_l = 7.5Nm: %.4f rad/s\n', omega_m_new);