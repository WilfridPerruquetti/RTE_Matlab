k=1.5;
z=0.5;
wn=2;
wp=wn*sqrt(1-z*z);
sys1=tf(k*wn*wn,[1 2*z*wn wn*wn]);

M=exp(-z*pi/sqrt(1-z*z));
t1=pi/wp;
t2=2*t1;
t3=3*t1;

figure(1)
[y,t]=step(sys1,0:0.01:10);
ylim([0 2])
yticks([0 0.5 0.9 1 1.5 1.6 1.7 1.8 1.9 2])
plot(t,y)
xp = [0.5 0.315];
yp = [0.85 0.85];
annotation('textarrow',xp,yp,'String','$k\left(1-e^{-\zeta\omega_{n}t} \cos(\omega_p t)-e^{-\zeta\omega_{n}t} \frac{\zeta \omega _{n}}{\omega_p} \sin(\omega_p t)\right)$','interpreter','latex')
hold on
x=0:0.1:10;
y=k*ones(length(x));
plot(x,y,'r--')
text(x(80),y(80),'DC gain $k$','interpreter','latex')

x=(0:0.1:1)*t1;
y=k*(1+M)*ones(length(x));
text(x(5),y(5)+0.1,'$k(1+M)$','interpreter','latex');
plot(x,y,'k-')

y=(0:0.1:1)*k*(1+M);
x=1*ones(size(y'))*t1;
text(x(5)+0.2,y(2),'$t_1$','interpreter','latex');
plot(x,y,'k')

x=(0:0.1:1)*t2;
y=k*(1-M*M)*ones(length(x));
text(x(7),y(7)-0.1,'$k(1-M^2)$','interpreter','latex');
plot(x,y,'k-')

y=(0:0.1:1)*k*(1-M*M);
x=1*ones(size(y'))*t2;
text(x(5)+0.2,y(2),'$t_2$','interpreter','latex');
plot(x,y,'k')

y=(0:0.1:1)*k*(1+M*M*M);
x=1*ones(size(y'))*t3;
text(x(5)+0.2,y(2),'$t_3$','interpreter','latex');
plot(x,y,'k')
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')

hLeg = legend('example')
set(hLeg,'visible','off')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters SecondOrderStepResponseZetaSmall

cleanfigure;
matlab2tikz('SecondOrderStepResponseZetaSmall.tex','width','\figwidth','height','\figheight','showInfo',false);

% figure(1)
% [y,t]=impulse(sys1);
% plot(t,y);
% text(t(30),y(30),'$\leftarrow \frac{k}{\tau}\exp\left( -\frac{t}{\tau}\right)$','interpreter','latex');
% hold on
% x=0:0.1:1;
% y=1-x;
% plot(x,y)
% text(0.5,0.5,'$\leftarrow$ slope $-k$','interpreter','latex')
% x = [0.3 0.26];
% y = [0.2 0.11];
% annotation('textarrow',x,y,'String','$\tau$','interpreter','latex')
% x = [0.3 0.13];
% y = [0.8 0.92];
% annotation('textarrow',x,y,'String','$\frac{k}{\tau}$','interpreter','latex')
% xlabel('$t [s]$','interpreter','latex')
% ylabel('$y(t)$','interpreter','latex')
% hLeg = legend('example')
% set(hLeg,'visible','off')
% 
% set(gcf,'Units','centimeters');
% screenposition = get(gcf,'Position');
% set(gcf,...
%     'PaperPosition',[0 0 screenposition(3:4)],...
%     'PaperSize',[screenposition(3:4)]);
% print -dpdf -painters FirstImpulse
% 
% cleanfigure;
% matlab2tikz('FirstImpulse.tex','width','\figwidth','height','\figheight','showInfo',false);
% 
% 
% figure(2)
% [y,t]=step(sys1);
% plot(t,y)
% text(t(25),y(25),'$\leftarrow k \left( 1-\exp\left( -\frac{t}{\tau}\right)\right)$','interpreter','latex');
% hold on
% x=0:0.1:1;
% y=tau*x;
% plot(x,y)
% text(x(10),y(10),'$\leftarrow$ slope $\frac{k}{\tau}$','interpreter','latex')
% x=0:0.1:1;
% y=0.63*ones(size(x'));
% plot(x,y,'k')
% y=0:0.063:0.63;
% x=1*ones(size(y'));
% u = [0.3 0.215];
% v = [0.2 0.11];
% annotation('textarrow',u,v,'String','$\tau$','interpreter','latex')
% plot(x,y,'k')
% hold on
% x=0:0.1:3;
% y=0.95*ones(size(x'));
% plot(x,y,'k')
% y=0:0.095:0.95;
% x=3*ones(size(y'));
% plot(x,y,'k');
% x = [0.45 0.39];
% y = [0.2 0.11];
% annotation('textarrow',x,y,'String','$3\tau$','interpreter','latex')
% xlabel('$t [s]$','interpreter','latex')
% ylabel('$y(t)$','interpreter','latex')
% yticks([0 0.1 0.2 0.3 0.4 0.5 0.6 0.63 0.7 0.8 0.9 0.95 1])
% hLeg = legend('example')
% set(hLeg,'visible','off')
% 
% set(gcf,'Units','centimeters');
% screenposition = get(gcf,'Position');
% set(gcf,...
%     'PaperPosition',[0 0 screenposition(3:4)],...
%     'PaperSize',[screenposition(3:4)]);
% print -dpdf -painters FirstStep
% 
% cleanfigure;
% matlab2tikz('FirstStep.tex','width','\figwidth','height','\figheight','showInfo',false);
% 
% figure(3)
% options = odeset('RelTol',1e-5);%,'Stats','on','OutputFcn',@odeplot) 
% [t,y]=ode23(@(t,y) -y+k*t,[0:0.01:10],0,options);
% plot(t,y);
% text(t(600),y(600),'$\leftarrow y(t)=k \left( (t-\tau)+\tau\exp\left( -\frac{t}{\tau}\right)\right).$','interpreter','latex');
% ylim([0 10]);
% hold on
% x=0:0.1:10;
% y=x-1;
% plot(x,y)
% text(3.5,2.5,'$\leftarrow$ slope $k$','interpreter','latex')
% x = [0.21 0.21];
% y = [0.21 0.11];
% annotation('textarrow',x,y,'String','$\tau$','interpreter','latex')
% xlabel('$t [s]$','interpreter','latex')
% ylabel('$y(t)$','interpreter','latex')
% hLeg = legend('example')
% set(hLeg,'visible','off')
% 
% set(gcf,'Units','centimeters');
% screenposition = get(gcf,'Position');
% set(gcf,...
%     'PaperPosition',[0 0 screenposition(3:4)],...
%     'PaperSize',[screenposition(3:4)]);
% print -dpdf -painters FirstRamp
% 
% cleanfigure;
% matlab2tikz('FirstRamp.tex','width','\figwidth','height','\figheight','showInfo',false);


