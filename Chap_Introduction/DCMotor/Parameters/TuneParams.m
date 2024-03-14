% Simulink
ti=0;
tf=0.4;
Ts=0.001;

% input frequency
f=10;

% Motor
error=0; % 0%
torque.value=0;
u0=2;% constant input for motor

% True initial state for Simulation
IC.ir=0.1;IC.thetar=1;IC.omegar=0.2;

% Noise
Noise.biais=0;
Noise.power=[0];
Noise.sampling=Ts/4;
Noise.seed=[23341]

% Reference
thetac=1;

