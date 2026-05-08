clc;
clear all;
close all;

%% Nominal model
num=[1 2];
den=[1 2 1.1 1];
Mytf=tf(num,den);

%% Data
load dataTemp;
lent=length(t);
u=ones(lent,1);
DataIdent = iddata(ynoisy,u,Ts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estimate models parameters  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% state spasce model parameter estimation
m1 = ssest(DataIdent,3,'Focus','simulation','Display','on','SearchMethod','lm') % select dimension of state (here 2)
[num1,den1]=ss2tf(m1.A,m1.B,m1.C,m1.D);
roots(den1)
m1lm=m1;
tf1lm=tf(num1,den1)

m1 = ssest(DataIdent,3,'Focus','simulation','Display','on','SearchMethod','gna') % select dimension of state (here 2)
[num1,den1]=ss2tf(m1.A,m1.B,m1.C,m1.D);
roots(den1)
m1gna=m1;
tf1gna=tf(num1,den1)

m1 = ssest(DataIdent,3,'Focus','simulation','Display','on','SearchMethod','gn') % select dimension of state (here 2)
[num1,den1]=ss2tf(m1.A,m1.B,m1.C,m1.D);
roots(den1)
m1gn =m1;
tf1gn=tf(num1,den1)
% save figure1
figure(1)
compare(DataIdent,m1lm,m1gna,m1gn);
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/ExFigTempCompareSysidSS
cleanfigure;
matlab2tikz('Figures/ExFigTempCompareSysidSS.tex','width','\figwidth','height','\figheight','showInfo',false);
% Best m1gna

% arx model parameter estimation
m2 = arx(DataIdent,[3 2 0]) % select orders (here 3 2 and no delay)
tf2=d2c(m2,'zoh');
figure(2)
compare(DataIdent,m2);
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
% save figure2
figure(2)
compare(DataIdent,m2);
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/ExFigTempCompareSysidArx
cleanfigure;
matlab2tikz('Figures/ExFigTempCompareSysidArx.tex','width','\figwidth','height','\figheight','showInfo',false);
% best m3cgn

% transfert function parameter estimation
m3gn = tfest(DataIdent,3,'Display','on','SearchMethod','gn') % select np=3,nz=2,iodelay=0 discrete model using Ts
roots(m3gn.Denominator)
tf3gn=tf(m3gn.Numerator,m3gn.Denominator) % from transfert function obtain new state space model parameters

m3gna = tfest(DataIdent, 3,'Display','on','SearchMethod','gna') % select np=3,nz=2,iodelay=0 discrete model using Tsm3cgna=d2c(m3,'zoh');
roots(m3gna.Denominator)
tf3gna=tf(m3gna.Numerator,m3gna.Denominator) % from transfert function obtain new state space model parameters

m3lm = tfest(DataIdent, 3,'Display','on','SearchMethod','lm') % select np=3,nz=2,iodelay=0 discrete model using Ts
roots(m3lm.Denominator)
tf3lm=tf(m3lm.Numerator,m3lm.Denominator) % from transfert function obtain new state space model parameters
% save figure3
figure(3)
compare(DataIdent,m3gn,m3gna,m3lm);
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/ExFigTempCompareSysidTF
cleanfigure;
matlab2tikz('Figures/ExFigTempCompareSysidTF.tex','width','\figwidth','height','\figheight','showInfo',false);
% same result ...

% pem
opt = n4sidOptions('Focus','simulation');
init_sys = n4sid(DataIdent,3,opt); 
init_sys.Report.Fit.FitPercent; % very small fit 2% with initial model
m4 = pem(DataIdent,init_sys,'Display','on','SearchMethod','gn') 
[num4,den4]=ss2tf(m4.A,m4.B,m4.C,m4.D);
roots(den4)
m4gn=m4;
tf4gn=tf(num4,den4)

m4 = pem(DataIdent,init_sys,'Display','on','SearchMethod','gna') 
[num4,den4]=ss2tf(m4.A,m4.B,m4.C,m4.D);
roots(den4)
m4gna=m4;
tf4gna=tf(num4,den4)

m4 = pem(DataIdent,init_sys,'Display','on','SearchMethod','lm') 
[num4,den4]=ss2tf(m4.A,m4.B,m4.C,m4.D);
roots(den4)
m4lm=m4;
tf4lm=tf(num4,den4) 
% save figure4
figure(4)
compare(DataIdent,m4gn,m4gna,m4lm);
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/ExFigTempCompareSysidPem
cleanfigure;
matlab2tikz('Figures/ExFigTempCompareSysidPem.tex','width','\figwidth','height','\figheight','showInfo',false);
% best m4lm

%Validating the Estimated Model to Experimental Output
figure(5)
compare(DataIdent,m1gna,m3gn,m4lm);
set(gcf,'DefaultLegendLocation','best')
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
% save figure1
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/ExFigTempCompareSysid
cleanfigure;
matlab2tikz('Figures/ExFigTempCompareSysid.tex','width','\figwidth','height','\figheight','showInfo',false);



