clear all;
clc;
ti=0;
tf=5;
dt=1e-3;

%% simulation
mysys='SimuHybrid_Ex2';
open_system(mysys);
% save Simulink as pdf
saveas(get_param('SimuHybrid_Ex2','Handle'),'Figures/SimuHybrid_Ex2.pdf');
% set time intervale simulation [ti tf]
set_param(mysys,'StartTime','ti','StopTime','tf');
% 
out = sim(mysys, 'ReturnWorkspaceOutputs', 'on');
pause(3);

%% Plot / Affichage
Myplot;

    
    