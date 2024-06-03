clear all;
clc;
% sampling
Ts=0.001;
% Simu
tf=2;

% Noise
Noise.biais=0;
Noise.power=[3e-6];%3e-6];
Noise.sampling=Ts;
Noise.seed=[23341];

% TWindow
Nw=100; % nombre de points: (N+1) points
TWindow=Ts*Nw;

% Param derivator
mu=0; % allways 0
k=0.32; % allway this value except if low noise k<0
n=1; % order of derivative to estimate
q=n; % cas causal: q=1, on prend ici les 2 premiers termes for higher order derivative q=n (causal)
 
% estimate delay
tau=Racine(mu,k,n)*TWindow



