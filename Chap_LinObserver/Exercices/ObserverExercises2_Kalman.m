Q = diag([20 10 30 10]);
R = 5;

[P,~,Kf] = care(A',C',Q,R);
Kf = Kf';

% xhat_dot = A*xhat + B*u + Kf*(y_meas - C*xhat);