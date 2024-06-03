%%%%%%%%%%%
%% Clear %%
%%%%%%%%%%%
clc; clear;

%%%%%%%%%%%%%%%%%%%%%%%%
%% Tunable parameters %%
%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulink
ti=0;tf=10;Ts=0.001; % sampling period
%% Noise
Noise.power=[1e-5]; %0, 1e-8, 1e-4, 1e-2
Noise.sampling=Ts;
Noise.seed=[23341];
%% Testing function for derivative estimation: sinus
a=2; % amplitude 
omega=2; % pulsation
%% Select order of derivative
n=1; % order of differentiator n+1
k=1; % order of derivative estimation (k<=n !!)
L=a*omega^n; % Lipchitz constant 
