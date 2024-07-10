clear all;
clc;
ti=0;
tf=15;
dt=1e-3;

%% simulation
mysys='SimuHybrid_Ex1';
open_system(mysys);
% save Simulink as pdf
saveas(get_param('SimuHybrid_Ex1','Handle'),'Figures/SimuHybrid_Ex1.pdf');
% set time intervale simulation [ti tf]
set_param(mysys,'StartTime','ti','StopTime','tf');
% 
out = sim(mysys, 'ReturnWorkspaceOutputs', 'on');
pause(3);

%% Plot / Affichage
Myplot;

    
    