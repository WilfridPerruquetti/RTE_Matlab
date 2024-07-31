clear all;
clc;
ti=0;
tf=5;
dt=1e-3;
dperiod = 0.5;
doffset = 0;
%% simulation
mysys='Simu_Algebraic';
open_system(mysys);
% save Simulink as pdf
saveas(get_param('Simu_Algebraic','Handle'),'Figures/SimuAlgebraic.pdf');
% set time intervale simulation [ti tf]
set_param(mysys,'StartTime','ti','StopTime','tf');
% 
out = sim(mysys, 'ReturnWorkspaceOutputs', 'on');
pause(3);

%% Plot / Affichage
Myplot;

    
    