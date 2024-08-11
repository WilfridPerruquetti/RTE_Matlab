clc;
clear all;
close all;

scenario=2; %2

switch scenario,
    % Load data
  case 1
    load('DCMotorData1.mat');
  case 2
    load('DCMotorData2.mat');
  otherwise
    error(['unhandled scenario = ',num2str(scenario)]); % Error handling
end
n=length(u);

% Construct the regressor matrix X and output vector Y
X = zeros(n-2, 4);  % Initialize X with zeros
Y = y(3:n);       % Y vector for y(k) starting from k=2

% Fill the matrix X with appropriate values
for i = 3:n
X(i-2, :) = [-y(i-1), -y(i-2), u(i-1), u(i-2)];
end

% or in a more compact form
X = [-y(2:n-1), -y(1:n-2), u(2:n-1), u(1:n-2)];

% Perform Least Squares estimation
theta_hat = (X' * X) \ (X' * Y);

% Display the estimated parameters
disp('Estimated Parameters:');
disp(['a1 = ', num2str(theta_hat(1))]);
disp(['a0 = ', num2str(theta_hat(2))]);
disp(['b1 = ', num2str(theta_hat(3))]);
disp(['b0 = ', num2str(theta_hat(4))]);

% Calculate the fitted values and residuals
y_hat = X * theta_hat;  % Predicted output
residuals = Y - y_hat; % Residuals
	
% Mean Squared Error (MSE)
MSE = mean(residuals.^2);
	
% Observed Residual Variance
observed_residual_variance = var(residuals);
	
% Coefficient of Determination R^2
R2 = 1 - sum(residuals.^2) / sum((y - mean(y)).^2);
	
% Display the results
fprintf('Vector of residuals (epsilon):\n');
fprintf('%.2g ', residuals);
fprintf('\n');
fprintf('Mean Squared Error (MSE): %.4f\n', MSE);
fprintf('Observed Residual Variance: %.4f\n', observed_residual_variance);
fprintf('R^2: %.4f\n', R2);


k=1:n;
% Plot the original and predicted outputs
figure;
plot(k(3:n), Y, 'ro-');
hold on;
plot(k(3:n), y_hat, 'bx-');
xlabel('$k$','Interpreter','latex');
ylabel('$y_k$','Interpreter','latex');
legend({'Original $y_k$','Fitted $y_k$'},'Interpreter','latex');
grid on;
title('Original vs Fitted Output');

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigurePredict

cleanfigure;
matlab2tikz('FigurePredict.tex','width','\figwidth','height','\figheight','showInfo',false);


% Display residuals
figure;
stem(k(3:n), residuals);
xlabel('$k$','Interpreter','latex');
ylabel('Residuals');
title('Residuals of the Fitted Model');
grid on;

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureResidual

cleanfigure;
matlab2tikz('FigureResidual.tex','width','\figwidth','height','\figheight','showInfo',false);
