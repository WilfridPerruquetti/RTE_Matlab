% k is estimated using means of the last values from the step response 
len=length(t);
omegab_final=omegab(len-2000:len);
kestimb=mean(omegab_final)/u0;
disp(['The mean of the noisy data gives k=',num2str(kestimb)]);

% Method 1: tau is estimated using z(t)=1/(1-y/(ku0)) and a log plot
T=0.01;% time window legnth used to estimate tau
pas=t(len)/len;
W=round(T/pas);
trash=omegab(1:W)/(kestimb*u0);
z=abs(1./(1-trash));
lz=log(z);
figure(2);
plot(t(1:W),lz,'r');
% if necessary refine T (until you see a "line")
intercept=0.143;
slope = t(1:W)\(lz-intercept);
tauestim=1/(slope);
disp(['An estimate of tau is tau=',num2str(tauestim)]);

% Method 2: tau estimated using graph y(2*tau)=0.95 k u_0
T=0.05;% time window of legnth greater than 3*tau
W=round(T/pas);
figure(3)
plot(t(1:W),omegab(1:W),'r',t(1:W),u0*(1-exp(-3))*kestimb*ones(W,1),'g')
grid
% then using a zoom read intersection of green and red curves at t=3tau=0.022 
prompt = 'Find estimate of 3tau (Zoom: intersection, with the green line)?';
ttt = input(prompt);
tauestim=ttt/3;
disp(['An estimate of tau is tau=',num2str(tauestim)]);