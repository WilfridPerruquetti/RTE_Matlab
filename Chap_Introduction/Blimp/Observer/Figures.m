z=States(:,1);
dz=States(:,2);

Nz=NoisyStates(:,1);
Ndz=NoisyStates(:,2);

Ez=EstimStates(:,1);
Edz=EstimStates(:,2);

figure(1)
plot(t,z,t,Nz,t,Ez)
xlabel('$t$','Interpreter','latex')
ylabel('$z(t),\hat z(t)$','Interpreter','latex')
legend('$z(t)$','$z(t)$ noisy','$\hat z(t)$','Interpreter','latex','Location','northwest')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figure1

cleanfigure;
matlab2tikz('Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);

figure(2)
plot(t,dz,t,Ndz,t,Edz)
xlabel('$t$','Interpreter','latex')
ylabel('$\dot z(t),\dot{\hat z}(t)$','Interpreter','latex')
legend('$\dot z(t)$','$\dot z(t)$ noisy','$\dot{\hat z}(t)$','Interpreter','latex','Location','northwest')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figure2

cleanfigure;
matlab2tikz('Figure2.tex','width','\figwidth','height','\figheight','showInfo',false);
