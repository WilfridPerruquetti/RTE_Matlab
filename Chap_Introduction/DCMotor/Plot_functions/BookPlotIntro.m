figure('Color',[0.8 0.8 0.8], ...
	'Colormap',hsv(10), ...
	'DoubleBuffer','on', ...
	'MenuBar','none', ...
	'Name','Motor', ...
	'NumberTitle','off', ...
	'Resize','on', ...
	'Tag','Motor');

omegab=NoisyStates(:,2);
       
plot(t,omegab,'r'), grid
xlabel('$t$ [s]','Interpreter','latex'), ylabel('$\omega$ [rad/s]','Interpreter','latex')
legend({'Noisy angular speed in red'},'Location','southeast','Orientation','horizontal')  
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
figurename=['Figures/Figure4.pdf'];
saveas(gcf,figurename);
figurename=['Figures/Figure4.tex'];
cleanfigure;
matlab2tikz(figurename,'width','\figwidth','height','\figheight','showInfo',false);
    


