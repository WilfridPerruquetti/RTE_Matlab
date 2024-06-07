t=out.t;
der=out.der;
Myzeroder=find_zc(t,der,0);

derEulerNonoise=out.derEulerNonoise;
MyzeroderEulerNonoise=find_zc(t,derEulerNonoise,0);

s=size(MyzeroderEulerNonoise);
delay1=mean(Myzeroder-MyzeroderEulerNonoise(2:s(1)))

derEulerNoise=out.derEulerNoise;
MyzeroderEulerNoise=find_zc(t,derEulerNonoise,0);
delay2=mean(Myzeroder-MyzeroderEulerNoise(2:s(1)))

der2ndFilter=out.der2ndFilter;
Myzeroder2ndFilter=find_zc(t,der2ndFilter,0);
delay3=mean(Myzeroder-Myzeroder2ndFilter(2:s(1)))

derDD=out.derDD;
MyzeroderDD=find_zc(t,derDD,0);
delay4=mean(Myzeroder-MyzeroderDD(2:s(1)))

figure('Name','Euler Derivative no noise')
plot(t,der,t,derEulerNonoise)
xlabel('$t$','Interpreter','latex')
ylabel('$\dot y(t)$','Interpreter','latex')
legend({'$\dot f(t)=10 \cos(10t)$','$\hat{\dot f}(t)=\frac{\Delta y}{\Delta t}$'},'Interpreter','latex')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure1

cleanfigure;
matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);


figure('Name','Euler Derivative with noise')
plot(t,der,t,derEulerNoise)
xlabel('$t$','Interpreter','latex')
ylabel('$\dot y(t)$','Interpreter','latex')
legend({'$\dot f(t)=10 \cos(10t)$','$\hat{\dot y}(t)=\frac{\Delta y}{\Delta t}$'},'Interpreter','latex')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure2

cleanfigure;
matlab2tikz('Figures/Figure2.tex','width','\figwidth','height','\figheight','showInfo',false);


figure('Name','2nd order filter Derivative with noise')
plot(t,der,t,der2ndFilter)
xlabel('$t$','Interpreter','latex')
ylabel('$\dot y(t)$','Interpreter','latex')
legend({'$\dot f(t)=10 \cos(10t)$','$\hat{\dot y}(t)=y_{\textrm{filter}}(t)$'},'Interpreter','latex')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure3

cleanfigure;
matlab2tikz('Figures/Figure3.tex','width','\figwidth','height','\figheight','showInfo',false);

figure('Name','Dirty Derivative with noise')
plot(t,der,t,derDD)
xlabel('$t$','Interpreter','latex')
ylabel('$\dot y(t)$','Interpreter','latex')
legend({'$\dot f(t)=10 \cos(10t)$','$\hat{\dot y}(t)=y_{\textrm{DD}}(t)$'},'Interpreter','latex')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure4

cleanfigure;
matlab2tikz('Figures/Figure4.tex','width','\figwidth','height','\figheight','showInfo',false);


