theta=States(:,1);
thetab=NoisyStates(:,1);
% figure 2 Theta
figure('Name','Motor Theta', ...
	'NumberTitle','off', ...
	'Resize','on', ...
	'Tag','Motor Theta');
plot(t,theta,'b',t,thetab,'r'), grid
xlabel('$t$ [s]','Interpreter','latex'), ylabel('$\theta$ [rad]','Interpreter','latex')
% save as pdf and tex    
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
saveas(gcf,'Figures/Figure2.pdf');
cleanfigure;
matlab2tikz('Figures/Figure2.tex','width','\figwidth','height','\figheight','showInfo',false);
close;

