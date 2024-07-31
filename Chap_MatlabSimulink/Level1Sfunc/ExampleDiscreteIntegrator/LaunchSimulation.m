clear all;
clc;
ti=0;
tf=5;
%% simulation
mysys='Simu_DiscreteInt';
open_system(mysys);
% save Simulink as pdf
saveas(get_param('Simu_DiscreteInt','Handle'),'Figures/Simu_DiscreteInt.pdf');
% set time intervale simulation [ti tf]
set_param(mysys,'StartTime','ti','StopTime','tf');
% 
out = sim(mysys, 'ReturnWorkspaceOutputs', 'on');
pause(3);

%% Plot / Affichage
Myplot;

    
    