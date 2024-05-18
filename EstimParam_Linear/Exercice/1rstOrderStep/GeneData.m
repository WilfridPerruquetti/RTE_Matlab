clear all;
clc;

%sys
k=1.6;
tau=0.2;
num=k;
den=[tau 1];
Mysys=tf(num,den);
Ts=0.01;
t=0:Ts:3;

% step response
[y]=step(Mysys,t);
ynoisy=y+0.05*randn(length(y),1);

save data.mat t Ts y ynoisy;