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
plot(t,x,t,y,t,z)

title('Continuous state','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
ylabel('$x,y,z$','Interpreter','latex')

