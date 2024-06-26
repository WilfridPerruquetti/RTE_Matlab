clear all;
clc;
close all;
load('data.mat');
% Plot
figure(1)
plot(t,y,t,ynoisy);
xlabel('time $t$ [s]','interpreter','latex')
ylabel('$y(t)$ noisy and noise-free data','interpreter','latex')
legend({'$y(t)$ Noise-free (blue)','$y(t)$ Noisy (red)'},'Interpreter','latex','Location','southeast');
% save figure1
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Ex1rstOrderStepResp
cleanfigure;
matlab2tikz('Figures/Ex1rstOrderStepResp.tex','width','\figwidth','height','\figheight','showInfo',false);

disp('Step response looks like a 1rst order step response')

% y=ku_0(1-e^{-\frac{t}{\tau}})
modelfun = @(param,t)(param(1)*(1-exp(-param(2)*t)));

%% Linear regression
len=length(t);
ynoisy_final=ynoisy(len-50:len);
kestim=mean(ynoisy_final);
disp(['kestim=',num2str(kestim)]);
% z(t)=1/(1-y/(ku0))
u0=1;
T=0.25;% well choosen
pas=Ts;
W=round(T/pas);
trash=ynoisy(1:W)/(-kestim*u0);
z=abs(1./(1-trash));
lz=log(z);
% Figure 2
figure(2)
plot(t(1:W),lz,'r')
xlabel('time $t$ [s]','interpreter','latex')
ylabel('$\log(z(t))$','interpreter','latex')
% save figure2
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Ex1rstOrderLogPlot
cleanfigure;
matlab2tikz('Figures/Ex1rstOrderLogPlot.tex','width','\figwidth','height','\figheight','showInfo',false);

slope = -t(1:W)'\lz;
tauestim=1/(slope);
disp(['tauestim=',num2str(tauestim)]);
param=[kestim;1/tauestim];
y_model=modelfun(param,t);
y_model=y_model';
residual1=sum((ynoisy - y_model).^2);
R2=1-residual1/sum((ynoisy - mean(ynoisy)).^2);
disp(['R2=',num2str(R2)]);
% Figure 3
figure(3)
plot(t,ynoisy,t,y_model);
xlabel('time $t$ [s]','interpreter','latex')
ylabel('$y(t)$ noisy and $y_m(t)$ (model)','interpreter','latex')
legend({'$y(t)$ Noise (blue)','$y_m(t)$ frome the obtained model (red)'},'Interpreter','latex','Location','southeast');
% save figure 3
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Ex1rstOrderCompModel
cleanfigure;
matlab2tikz('Figures/Ex1rstOrderCompModel.tex','width','\figwidth','height','\figheight','showInfo',false);

%% Nl regression
disp('Fiting not good enough=> NL Regression')
pas=Ts;
tinf= 0;
fitFirstDataInd=round(tinf/pas)+1;
tfin=2;
fitEndDataInd=round(tfin/pas);
% Select data for fitting
t_fit = t(fitFirstDataInd:fitEndDataInd) - t(fitFirstDataInd);
t_fit = t_fit';
f_fit = ynoisy(fitFirstDataInd:fitEndDataInd);
InitialGuess=[1.5985;2.65944];
% Nonlinear fit
[param,r,j] = nlinfit(t_fit,f_fit,modelfun,InitialGuess);
k = param(1);
tau = 1/param(2);
y = modelfun(param,t_fit);
% Figure 4
figure(4)
plot(t_fit,f_fit,'b',t_fit,y,'r')
legend({'$y(t)$ Noisy (blue)','$\hat y(t)$ (red)'},'Interpreter','latex','Location','southeast');
xlabel('$t$ [s]','Interpreter','latex');
residual2=sum((f_fit - y).^2);
R2=1-residual2/sum((ynoisy - mean(ynoisy)).^2);
disp(['NLINFIT result:  kestim=',num2str(k),',  tau=',num2str(tau),',  Residual=',num2str(residual2),'  R2=',num2str(R2)]);
% save figure 4
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Ex1rstOrderCompModel2NLReg
cleanfigure;
matlab2tikz('Figures/Ex1rstOrderCompModel2NLReg.tex','width','\figwidth','height','\figheight','showInfo',false);



