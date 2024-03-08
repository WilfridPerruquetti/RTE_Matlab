%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clear & Initialization of parameters %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
InitParams;

% Display system to simulate
printsys(A_nominal,B_nominal,C_nominal,D_nominal)

%%%%%%%%%%%%%%%%%%%%%%%
%% Launch simulation %%
%%%%%%%%%%%%%%%%%%%%%%%
mysys='Simulation_DCModel';
open_system(mysys);
set_param(mysys,'StartTime','ti','StopTime','tf');
sim(mysys);

% plot (callback dans le bloc de simu.)
% Exit
save_system(mysys);
close_system(mysys);
