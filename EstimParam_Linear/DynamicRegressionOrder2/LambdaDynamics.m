%%%%%%%%%%%%%%%%%%%%%
%% Lambda dynamics %%
%%%%%%%%%%%%%%%%%%%%%
zeta=0.7; %optimal with small overshoot
omega_n=10; %design parameter

ALambda=[0 1;-omega_n*omega_n -2*zeta*omega_n];
BLambda=[0;1];
DLambda=[0;0];
IC.omega=[1;1];

C_omega1=eye(2);
C_omega2=eye(2);

g1=16000;
g2=25000;
g3=600000;
g4=600000;

Gamma=[g1 0 0 0;
       0 g2 0 0;
       0 0  g3 0;
       0 0  0  g4];
