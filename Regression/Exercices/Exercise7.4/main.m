clear all;
clc;
% Load and plot data
database;
% data selection
x_data=NewPhase;
y_data=NewPolarization;
% Define the trigonometric model function
% 4 params theta_i
trigonometric_model = @(theta, x) theta(1)*sin(theta(2)*x).* cos(theta(3)*0.5*x).* sin(x-theta(4));
% Initial guess for parameter values
% theta1 -> [0 1]
% theta2 > 0
% theta3 > 0
% theta4 -> [0 180]
% theta_guess = [1.5; 1; 2; pi/6]
theta_guess = [1, 0, 0, 30]; % Adjust as needed

%% Perform nonlinear regression using lsqcurvefit
nlintool(x_data, y_data,trigonometric_model,theta_guess);
[theta_hat,R,J,COVB,MSE] = nlinfit(x_data, y_data,trigonometric_model,theta_guess);
% Generate model predictions using estimated parameters
x_line=0:0.1:25;
y_line=trigonometric_model(theta_hat, x_line);
y_est = trigonometric_model(theta_hat, x_data);

%% Performance evaluation
% Calculate SSR
residuals = y_data - y_est;
sum_squared_residuals = sum(residuals.^2);
% Calculate SST
sum_squared_total = sum((y_data - mean(y_data)).^2);
% Calculate R-squared
R_squared = 1 - sum_squared_residuals / sum_squared_total;

%% Plot the observational data and fitted model
figure;
plot(x_data, y_data, 'b.', x_line, y_line, 'r-', 'LineWidth', 1.5); 
xlabel('Phase Angle (degrees)');
ylabel('Degree of Polarization');
legend('Observational Data', 'Fitted Model');
title('Nonlinear Regression using Trigonometric Model');





