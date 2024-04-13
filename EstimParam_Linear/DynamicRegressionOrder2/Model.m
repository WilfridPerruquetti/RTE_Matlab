%%%%%%%%%%%%%%%%%%%%
%% Initialization %%
%%%%%%%%%%%%%%%%%%%%
% Simulink
ti=0;
tf=500;
Ts=0.0001;

% model parameters
a0=-10;
a1=2;
b0=3;
b1=2;
A_nominal=[0 1;-a0 -a1];
B_nominal=[0;1];
C_nominal=[b0 b1];
C_x=eye(2);
D_nominal=0;
D_x=[0;0];

sysNom = ss(A_nominal,B_nominal,C_nominal,D_nominal);
eig(A_nominal)
sysNom

error=0; % 0%
A_real=[0 1;-a0*(1+error) -a1*(1+error)];
B_real=[0;1];
C_real=C_nominal*(1+error);
D_real=D_nominal*(1+error);
sysReal = ss(A_real,B_real,C_real,D_real);
eig(A_real)
sysReal
% constant input
u0=2;

% True initial state for Simulation
IC.x1=0.1;IC.x2=0;
IC.state=[IC.x1;IC.x2];

% Noise
Noise.biais=0;
Noise.power=[3e-12];
Noise.sampling=Ts*40;
Noise.seed=[23341];
