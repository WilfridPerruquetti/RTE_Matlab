%data
anom=-1;bnom=2;Rnom=3;
t=linspace(0,2*pi,100);
t=t';
x= anom+Rnom*cos(t) -0.5 + (0.5+0.5)*rand(100,1);
y= bnom+Rnom*sin(t) -0.5 + (0.5+0.5)*rand(100,1);
save('datacircle.mat','x','y')