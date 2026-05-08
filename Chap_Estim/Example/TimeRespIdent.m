clc;
clear all;
close all;

%% Nominal model
num=[1 2];
den=[1 2 1.1 1];
Mytf=tf(num,den);

%% Data
load dataTemp;
yorigin=y;
figure(1)
plot(t,yorigin,t,ynoisy)
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
hLeg = legend('Example');
set(hLeg,'visible','off');
% save figure1
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/ExFigTempData
cleanfigure;
matlab2tikz('Figures/ExFigTempData.tex','width','\figwidth','height','\figheight','showInfo',false);

%% Graphical method
figure(2)
plot(t,ynoisy);
ylim([-0.5 3.5])
yticks([-0.5 0 0.5 0.9 1 1.5 2 2.5 3 3.5])
hold on;
xp = [0.5 0.24];
yp = [0.85 0.699];
annotation('textarrow',xp,yp,'String','$k\left(1-e^{-\zeta\omega_{n}t} \cos(\omega_p t)-e^{-\zeta\omega_{n}t} \frac{\zeta \omega _{n}}{\omega_p} \sin(\omega_p t)\right)$','interpreter','latex')
hold on;
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
hLeg = legend('NoisyData');
set(hLeg,'visible','off');

len1=length(t);
window=20;
% estim k
ynoisy_final=ynoisy(len1-window:len1);
kestim=mean(ynoisy_final);
disp(['kestim=',num2str(kestim)]);
x=0:0.1:40;
y=kestim*ones(length(x));
plot(x,y,'r--')
text(x(160),y(160)+0.1,'DC gain $k$','interpreter','latex')
% overshoot
t1=4.5;
n1=round(t1/Ts);
t2=8.3;
n2=round(t2/Ts);
t3=12.6;
n3=round(t3/Ts);
M=(ynoisy(n1)-kestim)/kestim;
zetaestim=-log(M)/sqrt(pi^2+log(M)^2);
disp(['zetaestim=',num2str(zetaestim)]);
Tp=t3-t1;
omeganestim=(2*pi)/(Tp*sqrt(1-zetaestim^2));
disp(['omeganestim=',num2str(omeganestim)]);
% plot t1
x=(0:0.1:1)*t1;
y=kestim*(1+M)*ones(length(x));
text(x(5),y(5)+0.1,'$k(1+M)$','interpreter','latex');
plot(x,y,'k-')
y=-0.5:0.1:kestim*(1+M+0.05);
x=1*ones(size(y'))*t1;
text(x(5)+0.2,y(2),'$t_1$','interpreter','latex');
plot(x,y,'k')
% plot t2
x=(0:0.1:1)*t2;
y=kestim*(1-M*M)*ones(length(x));
text(x(7),y(7)-0.1,'$k(1-M^2)$','interpreter','latex');
plot(x,y,'k-')
y=-0.5:0.1:1*kestim*(1-M*M+0.05);
x=1*ones(size(y'))*t2;
text(x(5)+0.2,y(2),'$t_2$','interpreter','latex');
plot(x,y,'k')
% plot t3
x=(0:0.1:1)*t3;
y=kestim*(1+M*M*M)*ones(length(x));
text(x(7),y(7)-0.1,'$k(1+M^3)$','interpreter','latex');
plot(x,y,'k-')
y=-0.5:0.1:1*kestim*(1+M*M*M);
x=1*ones(size(y'))*t3;
text(x(5)+0.2,y(2),'$t_3$','interpreter','latex');
plot(x,y,'k')
% save figure2
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/ExFigTempEstim
cleanfigure;
matlab2tikz('Figures/ExFigTempEstim.tex','width','\figwidth','height','\figheight','showInfo',false);

% model
numMod1=kestim*omeganestim*omeganestim;
denMod1=[1 2*zetaestim*omeganestim omeganestim*omeganestim];
sysMod1=tf(numMod1,denMod1);
[yMod1]=step(sysMod1,t);
residual1=sum((ynoisy - yMod1).^2);
R2=1-residual1/sum((ynoisy - mean(ynoisy)).^2);
disp(['R2=',num2str(R2)]);
% compare model
figure(3)
plot(t,yorigin,t,ynoisy,t,yMod1)
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
hLeg = legend('Step Rep. Compare')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/ExFigTempCompare
cleanfigure;
matlab2tikz('Figures/ExFigTempCompare.tex','width','\figwidth','height','\figheight','showInfo',false);







