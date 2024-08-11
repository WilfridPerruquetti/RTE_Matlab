% Given data
masses = [0.1, 0.2, 0.3, 0.4, 0.5]'; % Mass in kg
displacements = [0.0023, 0.0038, 0.0062, 0.0081, 0.011]'; % Displacement in meters

% Gravitational acceleration
g = 9.81; % m/s^2

% Calculate the force for each mass
forces = masses * g; % Force in Newtons

%% k computation
% using backslash operator
kest1=displacements\forces

% Perform linear fit to find spring constant k
p = polyfit(displacements, forces, 1);
k = p(1); % Spring constant k
% Display the result
fprintf('Estimated spring constant (k): %.2f N/m\n', k);

% filtered measurements
yf=k*displacements;
% Display the result
fprintf('Filtered measurements (yf):\n');
fprintf('%.3g ', yf);
fprintf('\n');

% vector of residuals.
epsilon=forces-yf;
% Display the result
fprintf('Vector of residuals (epsilon):\n');
fprintf('%.2g ', epsilon);
fprintf('\n');

% R^2
Rsquare=1 - sum((forces - yf).^2)/sum((forces - mean(forces)).^2);
% Display the result
fprintf('Rsquare: %.2f\n', Rsquare);

% Plotting the data and the linear fit
figure('Name','Spring stiffness');
scatter(displacements, forces, 'bo', 'DisplayName', 'Experimental Data');
hold on;
fit_line = polyval(p, displacements);
plot(displacements, fit_line, 'r-', 'DisplayName', sprintf('Fit: F = %.2f x', k));
xlabel('Displacement (m)');
ylabel('Force (N)');
title('Force vs. Displacement');
legend('show');
grid on;
hold off;

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureSpring

cleanfigure;
matlab2tikz('FigureSpring.tex','width','\figwidth','height','\figheight','showInfo',false);

