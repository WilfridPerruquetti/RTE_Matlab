a=1;
b=2;

% sampling
Ts=1/2000;

% Simu
tf=2;

% Noise
Noise.biais=0;
Noise.power=[1e-3];%3e-6];
Noise.sampling=Ts*100;
Noise.seed=[23341];

% Filter
% F1(s)
ts=0.1;
z=0.7;
ts=0.2;
w=2.9/ts;

num1=[w*w];
den1=[1 2*z*w w*w];

% 2nd order derivative
% F2(s)
ts=0.3;
tau=1e-1;
w=2.9/ts;
num2=[w*w];
den2=[1 2*z*w w*w];
den2=conv(den2,[tau 1]);
