% parameters 
a0=0.7;
a1=-1.3;
a2=0.6;

% data
x=-5:9;
yfree=a0+a1*x+a2*x.*x;
y=a0+a1*x+a2*x.*x+(1+1)*rand(1,15);

save('dataparabola.mat','x','y')