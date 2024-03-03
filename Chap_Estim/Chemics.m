clear all;
t=0:0.5:10.5;
k=1/30;
y=1.2*exp(-k*t)+0.03*rand(size(t));
figure(1)
plot(t,y)
z=-log(y/1.2);
kest=pinv(t')*z';