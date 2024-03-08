clear all;
clc;
%% Simulink parameters
Ts=0.01;
ti=0;
tf=10;
zc=10;
%% Noise
Noise.biais=0; %0.1, 0.5, 1, 10
Noise.power=[1e-4]; %1e-8, 1e-6, 1e-4, 1e-1
Noise.sampling=Ts;
Noise.seed=[23341];

%% Blimp parameters
%% 11 when \dot{z}<0 & u_z<0
a(1,1)=-0.28412;
b(1,1)=0.11214;
%% 12 when \dot{z}<0 & u_z>0
a(1,2)=-0.28412;
b(1,2)=0.06149;
%% 21 when \dot{z}>0 & u_z<0
a(2,1)=-0.34316;
b(2,1)=0.11214;
%% 22 when \dot{z}>0 & u_z>0
a(2,2)=-0.34316;
b(2,2)=0.06149;
%% Blimp state representation
Ab11=[0 1;0 a(1,1)];
Ab12=[0 1;0 a(1,2)];
Ab21=[0 1;0 a(2,1)];
Ab22=[0 1;0 a(2,2)];

Bb11=[0;b(1,1)];
Bb12=[0;b(1,2)];
Bb21=[0;b(2,1)];
Bb22=[0;b(2,2)];

A=Ab11;
B=Bb11;
C=[1 0];
D=[0];

A_real=A;
B_real=B;
Cx_nominal=eye(2);
D_real=[0;0];
IC.state=[5;0];

%% Poly car
PolyCarac=poly(A); 
a0=PolyCarac(3);
a1=PolyCarac(2);
%% Control design
% Control specifications
Controller.tr=5;
Controller.z=0.7;
% closed loop dynamics
Controller.wn=2.9/(Controller.tr);
Controller.pole1= 9/Controller.tr;% tau=Controller.tr/9
Controller.poly=[1 2*Controller.z*Controller.wn Controller.wn*Controller.wn];
Controller.poles=roots(Controller.poly);
K=place(A,B,Controller.poles)
% Reference gain
G=-1/(C*(A-B*K)^(-1)*B);
%% Observer design
% Observer specifications
Observer.z=2;
Observer.tr=2;
% poles selection
Observer.wn=6*Observer.z/Observer.tr;
Observer.poly2=[1 2*Observer.z*Observer.wn Observer.wn*Observer.wn];
Observer.poles=roots(Observer.poly2);
% Observer gain
L=place(A',C',Observer.poles)';
% state space matrices for the observer implementation in simulink
A_Obs=A;
B_Obs=[Bb11 L];
C_Obs=eye(2);
D_Obs=[0 0;0 0];
Observer.IC=[0;0];






