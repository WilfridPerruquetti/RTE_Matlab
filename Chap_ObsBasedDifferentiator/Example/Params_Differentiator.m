InitParams; 

%% Differentiator parameters
% HGD parameters (n, gain, theta)
paramsnHGD.n=n;
% l(i)=gain(i)*theta^i
paramsnHGD.gain=[2 1]*2; %n=1
paramsnHGD.theta=1.4;

% HGDR parameters (n, gain, theta)
paramsnHGDR.n=n;
% l(i)=gain(i)*theta^i
paramsnHGDR.gain=[6 10]; %n=1
paramsnHGDR.theta=1.5;

% HOSMD parameters (n, gain, theta)
paramsnHOSMD.n=n;
% ell(i)=gain(i)*theta^(1/(n-i+1))
paramsnHOSMD.gain=[15 40]; %n=1
paramsnHOSMD.theta=1.8;

% HomD parameters (n, gain, theta, alpha)
paramsnHomD.n=n;
% k(i)=gain(i)*theta^(1/(n-i+2));
paramsnHomD.gain=[15 50]; %n=1
paramsnHomD.theta=2;
paramsnHomD.alpha=0.75; % between 1-1/(n+1),1 n=1 => [0.5,1]

% HomDR
paramsnHomDR.n=n;
% k(i)=gain(i)*theta^(1/(n-i+2));
paramsnHomDR.gain=[15 30]; %n=1
paramsnHomDR.theta=1.2;
paramsnHomDR.alpha=0.85; % between 1-1/(n+1),1

% FxTHomDR
paramsnFxTHomDR.n=n;
paramsnFxTHomDR.gain0=[8 25]; %n=1
paramsnFxTHomDR.gainInfty=[10 30]; %n=1
paramsnFxTHomDR.theta0=1.1;
paramsnFxTHomDR.thetaInfty=2;
paramsnFxTHomDR.alpha0=0.85; % between 1-1/(n+1),1
paramsnFxTHomDR.alphaInfty=1.4; % >1





