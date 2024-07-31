clear all;
clc;
ti=0;
tf=1;

%% simulation
mysys='SimuBallBeam';
open_system(mysys);
% save Simulink as pdf
saveas(get_param('SimuBallBeam','Handle'),'Figures/SimuBallBeam.pdf');
% set time intervale simulation [ti tf]
set_param(mysys,'StartTime','ti','StopTime','tf');
% 
out = sim(mysys, 'ReturnWorkspaceOutputs', 'on');
pause(3);

%% Plot / Affichage
Myplot;

    
    