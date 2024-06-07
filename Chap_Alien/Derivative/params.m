clear all;
close all;
clc;

% signal
signal=2;

% sampling
Ts= 1/2000;

% Simu
tf=2;

% Noise
Noise.biais=0;
Noise.power=[1e-8];%3e-6];
Noise.sampling=Ts*100; %1000
Noise.seed=[23341];

% (N+1) points pour l'intégrale
NW=150; % pour Der3 utilise l'annulateur minimal
%NW=1000 % pour Der utilise affine

% TWindow (fenêtre de l'intégrale) 
TWindow=Ts*NW

% Parameter derivator
mu=0; % allways 0
k=-0.5;
%k=0.32; % allway this value except if low noise k<0
% q is the serie order (Jacobi orthogonal polynomials)
q=1; % causal: q=1, on prend ici les 2 premiers termes for higher order derivative q=n (causal)
n=1; % order of derivative to estimate

% estimate delay
tau=Racine(mu,k,n);
Retard=tau*TWindow;

ParamAlienInit=[Ts;TWindow;n;mu;k;q];
% Compute Q and Samp
[Samp,Q]=PolyQSamp(ParamAlienInit);
ParamAlien=[Samp,Q,TWindow,Ts];



