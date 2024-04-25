clear all;
clc;
a=1;
num=1;
den=[1 a];
Poly1=[-1 1];
Poly2=[-3/2 1/2];
P=conv(Poly1,Poly2);
Q=[-3 2];

%
Ts=0.001;
N=1000;
TWindow=N*Ts;

% Noise
Noise.biais=0;
Noise.power=[0];%3e-6];
Noise.sampling=Ts;
Noise.seed=[23341];
