t=-1:0.001:1;

y=2+t+(2-t).*exp(-2*t)-4*exp(-t);

plot(t,y)