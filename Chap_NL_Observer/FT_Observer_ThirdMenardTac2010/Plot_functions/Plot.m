x1chap=out.xchap(:,1);
x2chap=out.xchap(:,2);
x3chap=out.xchap(:,3);
t=out.t;
x1=out.x1;
x2=out.x2;
x3=out.x3;
y=out.y;

figure('Color',[0.8 0.8 0.8], ...
'Colormap',hsv(10), ...
'DoubleBuffer','on', ...
'MenuBar','none', ...
'Name','Second order', ...
'NumberTitle','off', ...
'Resize','on', ...
'Tag','Pendulum');

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
subplot(311), plot(t,x1,'b',t,y,'g',t,x1chap,'r'), grid
xlabel('$t (s)$','Interpreter','latex'), ylabel('$x_1,y,\hat{x}_1$','Interpreter','latex')
legend('$x_1(t)$','$y(t)$','$\hat{x}_1(t)$','Interpreter','latex')  

subplot(312), plot(t,x2,'b',t,x2chap,'r'), grid
xlabel('$t (s)$','Interpreter','latex'), ylabel('$x_2,\hat{x}_2$','Interpreter','latex')
legend('$x_2(t)$','$\hat{x}_2(t)$','Interpreter','latex')

subplot(313), plot(t,x3,'b',t,x3chap,'r'), grid
xlabel('$t (s)$','Interpreter','latex'), ylabel('$x_3,\hat{x}_3$','Interpreter','latex')
legend('$x_3(t)$','$\hat{x}_3(t)$','Interpreter','latex')

FigText = append(ObserverText,NoiseText);
figurename=['Figures/Figure' FigText '.pdf'];
saveas(gcf,figurename);
figurename=['Figures/Figure' FigText '.tex'];
cleanfigure;
matlab2tikz(figurename,'width','\figwidth','height','\figheight','showInfo',false);
        
        
        
       
    


