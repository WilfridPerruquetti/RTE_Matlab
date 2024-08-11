scenario=1; %2

switch scenario,
  case 1
    % Define the positions of the landmarks
    landmarks = [-1, 1; 1, 2; 3, 2; 4, 5];
    % robot distances to the landmarks
    y = [4; 5; 5; 8];
    % more accurate measured values should be y = [4.11; 4.57; 4.98; 8.13];
  case 2
    % Define the positions of the landmarks
    landmarks = [-1, -1; -1, 1; 1, -1; 1, 1];
    % robot distances to the landmarks
    y = [1.4; 1.4; 1.4; 1.4];
  otherwise
    error(['unhandled scenario = ',num2str(scenario)]); % Error handling
end

% Function to compute the distances
f = @(p) sqrt((p(1) - landmarks(:,1)).^2 + (p(2) - landmarks(:,2)).^2);	
% Least-squares criterion
SSE = @(p) sum((f(p) - y).^2);
	
% Initial guess for the position
p = [4; 3];
	
% Parameters for the Newton's method
tol = 1e-6;
max_iter = 100;
alpha = 0.8;  % Step size
pIterate=[p(1) p(2)];

for iter = 1:max_iter
distances = f(p);
residuals = distances - y;
	
% Gradient of SSE(p)
J = [(p(1) - landmarks(:,1))./distances, (p(2) - landmarks(:,2))./distances];
grad_j = 2 * J' * residuals;
	
% Update rule for Newton's method
delta_p = -J\residuals;
p = p + alpha * delta_p;
pIterate=[pIterate; p'];

% Check for convergence
if norm(delta_p) < tol
break;
end
end

% values
f(p)
SSE(p)
J
grad_j

	
% Display the estimated position
fprintf('Estimated position: (%.4f, %.4f)\n', p(1), p(2));
	

% Plotting the level curves
[x1, x2] = meshgrid(-5:0.1:9, -5:0.1:9);
J = arrayfun(@(x, y) SSE([x; y]), x1, x2);

figure('Name','Level Curves with estimated position');
contour(x1, x2, J, 50);
hold on;
plot(landmarks(:,1), landmarks(:,2), 'ro', 'MarkerFaceColor', 'r');
Mylen=length(pIterate);
for i=1:Mylen
    plot(pIterate(i,1),pIterate(i,2), 'bx', 'MarkerSize', 10, 'LineWidth', 2);
end
title('Level curves of the least-square criterion');
xlabel('$p_1=x$','Interpreter','latex');
ylabel('$p_2=y$','Interpreter','latex');
legend({'Level Curves $SSE(p)$', 'Landmarks', 'Estimated Position'}, 'interpreter','latex','Location', 'west');
grid on;
hold off;	

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);

switch scenario,
  case 1
    print -dpdf -painters FigureLevelEstimPosition
    cleanfigure;
    matlab2tikz('FigureLevelEstimPosition.tex','width','\figwidth','height','\figheight','showInfo',false);
  case 2
    print -dpdf -painters FigureLevelEstimPosition2
    cleanfigure;
    matlab2tikz('FigureLevelEstimPosition2.tex','width','\figwidth','height','\figheight','showInfo',false);
  otherwise
    error(['unhandled scenario = ',num2str(scenario)]); % Error handling
end


