t=out.t;
derAlien=out.der;
derExact=out.der1;
f=out.signal_no_noise;
MyNoise=out.noise;
y=out.noisy_signal;
NoiseText='NoNoise'; % NoisePower
DerText='Alien1'; % Alien
FigText = append(DerText,NoiseText);


figure('Name','Noise');
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
plot(MyNoise,'b'), grid
xlabel('$t (s)$','Interpreter','latex'), ylabel('$\nu$','Interpreter','latex')
legend('$\nu(t)$','Interpreter','latex')  
figurename=['Figures/FigureNoise' FigText '.pdf'];
saveas(gcf,figurename);
figurename=['Figures/FigureNoise' FigText '.tex'];
cleanfigure;
matlab2tikz(figurename,'width','\figwidth','height','\figheight','showInfo',false);
    
figure('Name','Output');
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
plot(t,f,'b',t,y,'r'), grid
xlabel('$t (s)$','Interpreter','latex'), ylabel('$f,y$','Interpreter','latex')
legend('$f(t)$','$y(t)$','Interpreter','latex')  
figurename=['Figures/FigureSignal' FigText '.pdf'];
saveas(gcf,figurename);
figurename=['Figures/FigureSignal' FigText '.tex'];
cleanfigure;
matlab2tikz(figurename,'width','\figwidth','height','\figheight','showInfo',false);
   

figure('Name','Der Alien');
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
plot(t,derExact,'b',t,derAlien,'r'), grid
xlabel('$t (s)$','Interpreter','latex'), ylabel('$\dot f,\hat{\dot f}$','Interpreter','latex')
legend('$\dot f(t)$','$\hat{\dot f}(t)$','Interpreter','latex')  
figurename=['Figures/FigureDerAlien' FigText '.pdf'];
saveas(gcf,figurename);
figurename=['Figures/Figure' FigText '.tex'];
cleanfigure;
matlab2tikz(figurename,'width','\figwidth','height','\figheight','showInfo',false);
        
        
        
       
    


