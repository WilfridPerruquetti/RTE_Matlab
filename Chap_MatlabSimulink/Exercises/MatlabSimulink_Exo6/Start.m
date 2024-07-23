%% Simulink parameters
ti=0;
tf=5;
mysimu='DiscretePredatorPrey';
open_system(mysimu);
set_param(mysimu,'Solver','ode45','StartTime','ti','StopTime','tf');

rx=0.1;
ry=0.05;
rz=0.03;
Kx=500;
Ky=300;
Kz=150;
axy=0.01;
ayz=0.005;
bxy=0.1;
byz=0.1;
Params=[rx;ry;rz;Kx;Ky;Kz;axy;ayz;bxy;byz];
%% Launch simu
out = sim(mysimu, 'ReturnWorkspaceOutputs', 'on');
pause(3); 

%% Affichage
%time
t=0:0.5:tf;
% input
u=out.control;
% dim state
a=size(out.state);
% discrete state
x=out.state(:,1);
y=out.state(:,2);
z=out.state(:,3);

figure('Name','Discrete state')
stairs(t,x)
hold on
stairs(t,y)
hold on
stairs(t,z)

title('Discrete state','Interpreter','latex')
xlabel('$t\, [s], \quad T_s=0.5\, [s]$','Interpreter','latex')
ylabel('$x_n,y_n,z_n$','Interpreter','latex')
legend('$x_n$','$y_n$','$z_n$','Interpreter','latex','Location','best')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureDiscretePredatorPrey

cleanfigure;
matlab2tikz('FigureDiscretePredatorPrey.tex','width','\figwidth','height','\figheight','showInfo',false);


