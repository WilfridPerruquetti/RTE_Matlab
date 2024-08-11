% continuous-time model
num=10;
den=[0.01 1 0];
ContDCmotor=tf(num,den);

% continuous-time model
DiscreteMotor=c2d(ContDCmotor,0.002,'zoh');

%% Generate Data

%% Scenario 1: step response
time=0:0.002:0.1;
% Number of data points
n=length(time);
% noise
noise=(0.002+0.002)*rand(n,1);
% input
u = ones(n,1); % input u(k)
y = step(DiscreteMotor,time)+noise; % output y(k)

% Plot the output response
figure('Name','Step response');
stem(0:n-1, y, 'filled');
xlabel('Sample Index k');
ylabel('Output y(k)');
title('Discrete-Time DC Motor Output Step Response');
grid on;

save('DCMotorData1.mat','u','y','a0','a1','b0','b1')

%% Scenario 2: step response
% Given system coefficients
a1 = DiscreteMotor.Denominator{1,1}(2); % coefficient a1
a0 = DiscreteMotor.Denominator{1,1}(3); % coefficient a0
b1 = DiscreteMotor.Numerator{1,1}(2); % coefficient b1
b0 = DiscreteMotor.Numerator{1,1}(3); % coefficient b0

% Input sequence (example: step input)
u = 10*sin(100*time)+20*sin(300*time); % input sequence

% Initialize output sequence y(k)
y = zeros(1, n); % Initialize output array with zeros

% Initial conditions (assume y(-1) = y(-2) = 0 for simplicity)
y_1 = 0; % y(k-1)
y_2 = 0; % y(k-2)
u_1 = 0; % u(k-1)
u_2 = 0; % u(k-2)

% Iterate through input to generate output response
for k = 1:n
    % Compute current output y(k) using the difference equation
    y(k) = -a1 * y_1 - a0 * y_2 + b1 * u_1 + b0 * u_2;
    % Update previous values for the next iteration
    y_2 = y_1;
    y_1 = y(k);
    u_2 = u_1;
    u_1 = u(k);
end
u=u';
y=y'+noise;

% Plot the output response
figure('Name','Sinus response');
stem(0:n-1, y, 'filled');
xlabel('Sample Index k');
ylabel('Output y(k)');
title('Discrete-Time DC Motor Output Response');
grid on;

save('DCMotorData2.mat','u','y','a0','a1','b0','b1')

