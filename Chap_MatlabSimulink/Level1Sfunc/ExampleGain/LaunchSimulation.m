clear all;
clc;
ti=0;
tf=5;
dt=1e-3;
dperiod = 0.5;
doffset = 0;
%% simulation
mysys='Simu_gain';
open_system(mysys);
% save Simulink as pdf
saveas(get_param('Simu_gain','Handle'),'Figures/Simu_gain.pdf');
% set time intervale simulation [ti tf]
set_param(mysys,'StartTime','ti','StopTime','tf');
% 
out = sim(mysys, 'ReturnWorkspaceOutputs', 'on');
pause(3);

%% Plot / Affichage
Myplot;

    
    