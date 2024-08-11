% Define the positions of the landmarks
landmarks = [-1, 1; 1, 2; 3, 2; 4, 5];
y = [4; 5; 5; 8];
	
% Function to compute the distances
f = @(p) sqrt((p(1) - landmarks(:,1)).^2 + (p(2) - landmarks(:,2)).^2);
	
% Least-squares criterion
SSE = @(p) sum((f(p) - y).^2);
	
% Generate grid points
[x1, x2] = meshgrid(-5:0.1:9, -5:0.1:9);
J = arrayfun(@(x, y) SSE([x; y]), x1, x2);
	
% Plot the level curves
figure('Name','Level Curves');
contour(x1, x2, J, 50);
hold on;
plot(landmarks(:,1), landmarks(:,2), 'ro', 'MarkerFaceColor', 'r');
xlabel('$p_1=x$','Interpreter','latex');
ylabel('$p_2=y$','Interpreter','latex');
title('Level curves of the least-square criterion');
legend({'Level Curves $SSE(p)$','Landmarks'},'interpreter','latex','Location','best')
grid on;
hold off;

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureLevel

cleanfigure;
matlab2tikz('FigureLevel.tex','width','\figwidth','height','\figheight','showInfo',false);

