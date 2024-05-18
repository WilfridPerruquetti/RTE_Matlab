clc;
clear all;

%% Nominal model
num=[1 2];
den=[1 2 1.1 1];
Mytf=tf(num,den);

%% Data
load dataFreq;
figure(1)
bodeplot(data,'ob');
hold on;
bodeplot(dataNoisy,'xr');
% good 
np = 3;
sys = tfest(data,np); 
tf1=tf(sys.Numerator,sys.Denominator);

% Noisy
np = 3;
sys = tfest(dataNoisy,np); 
sys.Numerator;
sys.Denominator;
tf2=tf(sys.Numerator,sys.Denominator);








