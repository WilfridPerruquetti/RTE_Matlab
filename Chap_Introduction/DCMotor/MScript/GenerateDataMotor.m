%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set parameters for "experimental data" %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
InitParams;

%%%%%%%%%%%%%%%%%%%%%%%
%% Launch simulation %%
%%%%%%%%%%%%%%%%%%%%%%%
mysys='Simulation_DCModel';
open_system(mysys);
set_param(mysys,'StartTime','ti','StopTime','tf','Solver','ode5');
sim(mysys);

%%%%%%%%%%%%%%%%
%% Plot Figures
%%%%%%%%%%%%%%%%
PlotTimeMotor;

%%%%%%%%%%%%%%
% Save data %%
%%%%%%%%%%%%%%
save Data/ExpMotor.mat u0 t Voltage theta thetab omega omegab;
save Data/ParamsMotor.mat R L ke b Jtot k tau




