% Main function to compute I1 and I2 and plot the results
Ts = 0.005; % Sampling period
T = 0.1; % Given T
k=4;
% Define the signal y(t) = sin(t)
y_func = @(t) sin(t);

% Define the polynomial P(tau)
P = @(tau) 2 - 3 * tau;

% Define the polynomial Q(tau, t, T)
Q = @(tau, t, T) -60 * (7*t^2 - 14*t*tau + 7*tau.^2 + t*T - T*tau - 2*T^2);
   
% Define time range
t_values = 0:Ts:3;

% Initialize arrays for I1 and I2
I1_values = zeros(size(t_values));
I2_values = zeros(size(t_values));

% Loop over each t to compute I1 and I2
for i = 2:length(t_values)
    t = t_values(i);
    I1_values(i) = FuncComputeI1(y_func, t, Ts, P);
    I2_values(i) = FuncComputeI2(y_func, t, T, Ts, k, Q);
end

% Plot the results
figure('Name','Integral I1');
plot(t_values, I1_values, 'b-', 'LineWidth', 0.5);
title('$I_1(y,t)$ vs $t$','Interpreter','latex');
xlabel('$t [s]$','Interpreter','latex');
ylabel('$I_1(y,t)$','Interpreter','latex');
legend('$I_1(y,t)$','Interpreter','latex','Location','best')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureComputeI1

cleanfigure;
matlab2tikz('Figures/FigureComputeI1.tex','width','\figwidth','height','\figheight','showInfo',false);

figure('Name','Integral I2');
plot(t_values, I2_values, 'r-', 'LineWidth', 0.5);
title('$I_2(y,t,T)$ vs $t$','Interpreter','latex');
xlabel('$t [s]$','Interpreter','latex');
ylabel('$I_2(y,t,T)$','Interpreter','latex');
legend('$I_2(y,t,T)$','Interpreter','latex','Location','best')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureComputeI2

cleanfigure;
matlab2tikz('Figures/FigureComputeI2.tex','width','\figwidth','height','\figheight','showInfo',false);