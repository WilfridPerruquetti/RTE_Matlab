% Define the positions of the landmarks
landmarks = [-1, 1; 1, 2; 3, 2; 4, 5];
y = [4; 5; 5; 8];
	
% Function to compute the distances
f = @(p) sqrt((p(1) - landmarks(:,1)).^2 + (p(2) - landmarks(:,2)).^2);
	
% Least-squares criterion
j = @(p) sum((f(p) - y).^2);

% Initial guess for the position
initial_guess = [4; 3];
		
% Define the model function
model = @(p, ~) f(p);

% Use nlinfit to find the best estimate
p_est = nlinfit(zeros(4,1), y, model, initial_guess);
% Display the estimated position
disp('Estimated position:');
disp(p_est);

f(p_est)
j(p_est)

% Use nlinfit to find the best estimate with weights
options = statset('nlinfit');
options.RobustWgtFun = 'bisquare';
p_estW = nlinfit(zeros(4,1), y, model, initial_guess, options);
		
% Display the estimated position
disp('Estimated position:');
disp(p_estW);

f(p_estW)
j(p_estW)