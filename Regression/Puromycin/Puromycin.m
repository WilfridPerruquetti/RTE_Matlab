clc;
clear;
close all;
	
	x = [0.02; 0.02; 0.06; 0.06; 0.11; 0.11; 0.22; 0.22; 0.56; 0.56; 1.10; 1.10];
	y = [76; 47; 97; 107; 123; 139; 159; 152; 191; 201; 207; 200];
	
	model = @(theta,x) theta(1) * x ./ (theta(2) + x);
	theta0 = [200; 0.05];
	
	options = optimoptions('lsqcurvefit', ...
	'Algorithm','levenberg-marquardt', ...
	'Display','iter');
	
	[theta_hat,resnorm,residual,exitflag,output,lambda,J] = ...
	lsqcurvefit(model, theta0, x, y, [], [], options);
	
	y_hat = model(theta_hat, x);
	SSE = residual' * residual;
	s2 = SSE / (length(y) - length(theta_hat));
	Cov_theta = s2 * inv(J' * J);
	se_theta = sqrt(diag(Cov_theta));
	
	fprintf('theta_hat =\n');
	disp(theta_hat);
	fprintf('SSE = %.6f\n', SSE);
	disp('Standard errors =');
	disp(se_theta);
	
	figure;
	subplot(1,2,1);
	plot(x, y, 'o', x, y_hat, '-', 'LineWidth', 1.5);
	grid on;
	xlabel('x'); ylabel('y');
	title('Observed and fitted data');
	legend('Data','Nonlinear fit','Location','southeast');
	
	subplot(1,2,2);
	plot(y_hat, residual, 'o', 'LineWidth', 1.5);
	grid on;
	xlabel('Fitted values'); ylabel('Residuals');
	title('Residual plot');
	yline(0,'--k');

   saveas(gcf,'FigurePuromycin.pdf')