k=1;
tau=1;
sys1=tf(k,[tau 1]);

figure(1)
[y,t]=impulse(sys1);
plot(t,y);
text(t(30),y(30),'$\leftarrow \frac{k}{\tau}\exp\left( -\frac{t}{\tau}\right)$','interpreter','latex');
hold on
x=0:0.1:1;
y=1-x;
plot(x,y)
text(0.5,0.5,'$\leftarrow$ slope $-k$','interpreter','latex')
x = [0.3 0.26];
y = [0.2 0.11];
annotation('textarrow',x,y,'String','$\tau$','interpreter','latex')
x = [0.3 0.13];
y = [0.8 0.92];
annotation('textarrow',x,y,'String','$\frac{k}{\tau}$','interpreter','latex')
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
hLeg = legend('example')
set(hLeg,'visible','off')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FirstImpulse

cleanfigure;
matlab2tikz('FirstImpulse.tex','width','\figwidth','height','\figheight','showInfo',false);


figure(2)
[y,t]=step(sys1);
plot(t,y)
text(t(25),y(25),'$\leftarrow k \left( 1-\exp\left( -\frac{t}{\tau}\right)\right)$','interpreter','latex');
hold on
x=0:0.1:1;
y=tau*x;
plot(x,y)
text(x(10),y(10),'$\leftarrow$ slope $\frac{k}{\tau}$','interpreter','latex')
x=0:0.1:1;
y=0.63*ones(size(x'));
plot(x,y,'k')
y=0:0.063:0.63;
x=1*ones(size(y'));
u = [0.3 0.215];
v = [0.2 0.11];
annotation('textarrow',u,v,'String','$\tau$','interpreter','latex')
plot(x,y,'k')
hold on
x=0:0.1:3;
y=0.95*ones(size(x'));
plot(x,y,'k')
y=0:0.095:0.95;
x=3*ones(size(y'));
plot(x,y,'k');
x = [0.45 0.39];
y = [0.2 0.11];
annotation('textarrow',x,y,'String','$3\tau$','interpreter','latex')
xlabel('$t [s]$','interpreter','latex')
ylabel('$y(t)$','interpreter','latex')
yticks([0 0.1 0.2 0.3 0.4 0.5 0.6 0.63 0.7 0.8 0.9 0.95 1])
hLeg = legend('example')
set(hLeg,'visible','off')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FirstStep

cleanfigure;
matlab2tikz('FirstStep.tex','width','\figwidth','height','\figheight','showInfo',false);