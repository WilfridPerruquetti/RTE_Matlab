figure(1);
% figure('Color',[0.8 0.8 0.8], ...
% 	'Colormap',hsv(10), ...
% 	'DoubleBuffer','on', ...
% 	'MenuBar','none', ...
% 	'Name','Motor', ...
% 	'NumberTitle','off', ...
% 	'Resize','on', ...
% 	'Tag','Motor');

%omegab=NoisyStates(:,2);
thetab=NoisyStates(:,1)

       
plot(t,thetab,'r'), grid
xlabel('$t$ [s]','Interpreter','latex'), ylabel('$\theta$ [rad]','Interpreter','latex')
legend({'Noisy angular position in red'},'Location','southeast','Orientation','horizontal')  
% set(gcf,'Units','centimeters');
% screenposition = get(gcf,'Position');
% set(gcf,...
%     'PaperPosition',[0 0 screenposition(3:4)],...
%     'PaperSize',[screenposition(3:4)]);
% figurename=['Figures/Figure5.pdf'];
% saveas(gcf,figurename);
% figurename=['Figures/Figure5.tex'];
% cleanfigure;
% matlab2tikz(figurename,'width','\figwidth','height','\figheight','showInfo',false);
    
kest=0.621;
tehta0est=0.99;

NewData=NoisyStates(:,1)-tehta0est-kest*u0*t;

figure(2)
plot(t,NewData,'r'), grid



