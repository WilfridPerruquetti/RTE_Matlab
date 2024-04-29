clear all;
clc;
close all;


k=1.5;
wn=2;
j=1;


figure('Name','2nd order step response'); 
legend('$\zeta$','interpreter','latex');
xlabel('$t [s]$','interpreter','latex');
ylabel('$y(t)$','interpreter','latex');
f1 = gca; hold on;

figure('Name','2nd order impulse response'); 
legend('$\zeta$','interpreter','latex');
xlabel('$t [s]$','interpreter','latex');
ylabel('$y(t)$','interpreter','latex');
f2 = gca; hold on;
for z=0.15:0.2:1.55
    leg(j,:) = ['$\zeta=' num2str(z) '$'];
    sys1=tf(k*wn*wn,[1 2*z*wn wn*wn]);
    [y,t]=step(sys1,0:0.1:25);
    plot(f1,t,y);
    hold on;
    [y2,t]=impulse(sys1,0:0.1:25);
    plot(f2,t,y2);
    hold on;
    j = j+1;
end;
 
legend(f1,leg);
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters StepSecondOrderZeta

cleanfigure;
matlab2tikz('StepSecondOrderZeta.tex','width','\figwidth','height','\figheight','showInfo',false);

legend(f2,leg);
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters ImpulseSecondOrderZeta

cleanfigure;
matlab2tikz('ImpulseSecondOrderZeta.tex','width','\figwidth','height','\figheight','showInfo',false);

