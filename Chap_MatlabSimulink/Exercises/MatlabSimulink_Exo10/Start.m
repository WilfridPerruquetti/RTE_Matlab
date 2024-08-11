clear all;
clc;
close all;
%% Simulink parameters
ti=0;
timef=20;

level=1; % =1; Level1 =2; Level 2 =3 Level 2 C
switch level
    case 1
        mysimu='BouncingBallLevel1';
    case 2
        mysimu='BouncingBallLevel2';
    case 3
        mysimu='BouncingBallLevel2C';
    otherwise
        % Unhandled case
        error(['Unhandled Level', num2str(level)]);
end

open_system(mysimu);
set_param(mysimu,'Solver','ode45','StartTime','ti','StopTime','timef');

% Bouncing Ball Parameters
g = 9.81;   % Acceleration due to gravity (m/s^2)
e = 0.8;    % Coefficient of restitution

Params=[g;e];

%% Launch simu
out = sim(mysimu, 'ReturnWorkspaceOutputs', 'on');
pause(3); 

%% Affichage
%time
t=out.time;
% continuous state
y=out.state(:,1);
v=out.state(:,2);

figure('Name','Continuous state')
plot(t,y,t,v)
title('Continuous state','Interpreter','latex')
xlabel('$t\, [s]$','Interpreter','latex')
ylabel('$y(t),v(t)$','Interpreter','latex')
legend('$y(t)$','$v(t)$','Interpreter','latex','Location','best')

set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureCont

cleanfigure;
matlab2tikz('FigureCont.tex','width','\figwidth','height','\figheight','showInfo',false);
