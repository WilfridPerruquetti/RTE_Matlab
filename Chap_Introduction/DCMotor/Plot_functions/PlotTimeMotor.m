% new figure
figure('Name','Motor', ...
	'NumberTitle','off', ...
	'Resize','on', ...
	'Tag','Motor');
% data
theta=States(:,1);
thetab=NoisyStates(:,1);
omega=States(:,2);
omegab=NoisyStates(:,2);
i=States(:,3);
ib=NoisyStates(:,3);
% plot
subplot(321), plot(t,theta,'b',t,thetab,'r'), grid
xlabel('$t$ [s]','Interpreter','latex'), ylabel('$\theta$ [rad]','Interpreter','latex')
subplot(322), plot(t,omega,'b',t,omegab,'r'), grid
xlabel('$t$ [s]','Interpreter','latex'), ylabel('$\omega$ [rad/s]','Interpreter','latex')
subplot(323), plot(t,i,'b',t,ib,'r'), grid
xlabel('$t$ [s]','Interpreter','latex'), ylabel('$i$ [A]','Interpreter','latex')
subplot(325), plot(t,Load,'r'), grid
xlabel('$t$ [s]','Interpreter','latex'), ylabel('$\Gamma_c$ [N]','Interpreter','latex')
subplot(326), plot(t,Voltage,'b'), grid
xlabel('$t$ [s]','Interpreter','latex'), ylabel('$u$ [V]','Interpreter','latex')
% save as pdf and tex
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
saveas(gcf,'Figures/Figure1.pdf');
cleanfigure();
%matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);
close;

