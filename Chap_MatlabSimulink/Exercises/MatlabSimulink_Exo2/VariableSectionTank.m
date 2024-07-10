%\dot{h}(t)=\frac{q_{1}+q_{2}-s\sqrt{2gh(t)}}{S(h(t))+\frac{\partial S}{\partial h}h(t)}.
%$r(h)=1+h(h-1)$, $q_1=0.1 \sin(t), q_2=0.15 \cos(t)$, $s=0.01, S=0.1$

%% Simu
f = @(t,x) [(0.1*sin(t)+0.15*cos(t)-0.01*sqrt(2*9.81*x))/(pi*0.1^2*(1+x*(x-1))^2+2*pi*0.1^2*(2*x-1)*(1+x*(x-1)))];
%
opts = odeset('Reltol',1e-13,'AbsTol',1e-14,'Stats','on');
% Simu 1
[t,h] = ode45(f,[0 3],[0.4],opts);

figure('Name','Variable Section Tank')
plot(t,h,'b')
xlabel('$t$','Interpreter','latex')
ylabel('$h$','Interpreter','latex')
legend('$h(t)$','Interpreter','latex')

%saveas(gcf,'Figures/Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureVariableSectionTank1

cleanfigure;
matlab2tikz('Figures/FigureVariableSectionTank.tex','width','\figwidth','height','\figheight','showInfo',false);