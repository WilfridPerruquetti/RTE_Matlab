clear all;
clc;
Ts=0.01;

t=0:Ts:40;
n=length(t);
t=t';
myone=1*ones(1,n);
myone=myone';

theta=[1;-1];
Gamma=0.5*eye(2);
Hat_theta=zeros(n,2);
Hat_theta(1,1)=0;
Hat_theta(1,2)=0;


Noisy=wgn(n,1,-2)/10;
var(Noisy);
Hat_thetaNoisy=zeros(n,2);
Hat_thetaNoisy(1,1)=Noisy(1);
Hat_thetaNoisy(1,2)=Noisy(1);

Noisy=wgn(n,1,-2);
var(Noisy);

% EX1
phi=[exp(-t) myone];
for i=2:n
    yti=phi(i,1)*theta(1)+phi(i,2)*theta(2);
    Hatyti=phi(i,1)*Hat_theta(i-1,1)+phi(i,2)*Hat_theta(i-1,2);
    Hat_theta(i,:)=Hat_theta(i-1,:)-(Ts*(Gamma*phi(i,:)'*(Hatyti-yti)))';
    noise=Noisy(i);
    Hat_thetaNoisy(i,:)=Hat_thetaNoisy(i-1,:)-(Ts*(Gamma*phi(i,:)'*((Hatyti-yti)+noise)))';
end;

figure(1)
%subplot(1,2,1)
plot(t,Hat_theta);
figure(2)
%subplot(1,2,2)
plot(t,Hat_thetaNoisy);


% EX2
phi=[sin(t) myone];
for i=2:n
    yti=phi(i,1)*theta(1)+phi(i,2)*theta(2);
    Hatyti=phi(i,1)*Hat_theta(i-1,1)+phi(i,2)*Hat_theta(i-1,2);
    Hat_theta(i,:)=Hat_theta(i-1,:)-(Ts*(Gamma*phi(i,:)'*(Hatyti-yti)))';
    noise=Noisy(i);
    Hat_thetaNoisy(i,:)=Hat_thetaNoisy(i-1,:)-(Ts*(Gamma*phi(i,:)'*((Hatyti-yti)+noise)))';
end;

figure(3)
%subplot(1,2,1)
plot(t,Hat_theta);
figure(4)
%subplot(1,2,2)
plot(t,Hat_thetaNoisy);