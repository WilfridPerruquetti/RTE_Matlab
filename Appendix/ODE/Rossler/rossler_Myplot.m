% Parameters for the Rossler attractor
a = 0.2;
b = 0.2;
c = 5.8;

% Time span and initial conditions
tspan = [0 200];
initial_conditions = [1 1 1];  % [x0, y0, z0]

% Define the Rossler system of differential equations
rossler = @(t, xyz) [-xyz(2) - xyz(3);
                      xyz(1) + a*xyz(2);
                      b + xyz(3)*(xyz(1) - c)];

opts = odeset('Reltol',1e-13,'AbsTol',1e-14,'Stats','on');

% Solve the system using ode45
[t, xyz] = ode45(rossler, tspan, initial_conditions,opts);

% Extract the solutions for x, y, and z
x = xyz(:, 1);
y = xyz(:, 2);
z = xyz(:, 3);

% Plot the 3D trajectory
figure
plot3(x, y, z, 'LineWidth', 1);
title('Rössler Attractor','Interpreter','latex');
xlabel('$x$','Interpreter','latex');
ylabel('$y$','Interpreter','latex');
zlabel('$z$','Interpreter','latex');
grid on;
axis tight;

legend('$x(0)=1,y(0)=1,z(0)=1$','Interpreter','latex','Location','northwest')

%saveas(gcf,'Figure.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figure

cleanfigure;
matlab2tikz('Figure.tex','width','\figwidth','height','\figheight','showInfo',false);

