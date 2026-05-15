set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

A = [0 1 0 0;
     0 0 -g 0;
     0 0 0 1;
     -m*g/J 0 0 0];
B = [0; 0; 0; 1/J];
C = [1 0 0 0];

polesObs = [-4 -5 -6 -7];
L = place(A',C',polesObs)';

% xhat_dot = A*xhat + B*u + L*(y_meas - C*xhat);
		