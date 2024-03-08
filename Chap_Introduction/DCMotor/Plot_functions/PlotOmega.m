omega=States(:,2);
omegab=NoisyStates(:,2);
% figure 3 angular speed
figure('Name','Motor Omega', ...
	'NumberTitle','off', ...
	'Resize','on', ...
	'Tag','Motor Omega');
plot(t,omega,'b',t,omegab,'r'), grid
xlabel('$t$ [s]','Interpreter','latex'), ylabel('$\omega$ [rad/s]','Interpreter','latex')
legend({'Angular speed in blue','Noisy anular speed in red'},'Location','southeast','Orientation','horizontal')  
% save as pdf and tex  
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
saveas(gcf,'Figures/Figure3.pdf');
cleanfigure;
matlab2tikz('Figures/Figure3.tex','width','\figwidth','height','\figheight','showInfo',false);
    


