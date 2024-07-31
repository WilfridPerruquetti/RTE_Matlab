clear all;
clc;
ti=0;
tf=5;
dt=1e-3;
dperiod = 0.5;
doffset = 0;
%% simulation
mysys='SimuDiscrete_Ex1';
open_system(mysys);
% save Simulink as pdf
saveas(get_param('SimuDiscrete_Ex1','Handle'),'Figures/SimuDiscrete_Ex1.pdf');
% set time intervale simulation [ti tf]
set_param(mysys,'StartTime','ti','StopTime','tf');
% 
out = sim(mysys, 'ReturnWorkspaceOutputs', 'on');
pause(3);

%% Plot / Affichage
Myplot;

    
    