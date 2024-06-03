clear all;
clc;
% process parameters 
a=3;
num=1;
den=[1 a];
% sampling
Ts=0.001;
% samples 
N=1000;
% final time
tf=N*Ts;

% Noise
Noise.biais=0;
Noise.power=[3e-6];%3e-6];
Noise.sampling=Ts;
Noise.seed=[23341];

% Nwindow (use this samples to get estimate)
NWindow=10000;

% Poly for convolution 
Poly1=[-1 1];
Poly2=[-3/2 1/2];
P=conv(Poly1,Poly2);
Q=[-3 2];


% Filtre
w=10;
z=1.5;
num=[w*w];
den=[1 2*z*w w*w];

num=1;
den=1;



