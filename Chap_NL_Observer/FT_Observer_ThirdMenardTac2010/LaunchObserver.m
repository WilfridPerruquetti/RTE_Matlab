
%% Clear
clear all;
clc;

%% Model parammeters
% \begin{eqnarray}
% 	\dot{x}_{1}&= x_2
% \dot x_2=x_3+x_1 sin(x_2)
% \dot x_3=sin(x_1+x_2+x_3)+u
% 	y&=& x_{1} 
% \end{eqnarray}

 
% sin input
a=2;
omega=10;


%% Simulink
ti=0;
tf=10;
Ts=0.01;

%% Noise
Noise.biais=1; %0.1, 0.5, 1, 10
NoiseText='NoNoise'; Noise.power=[0];
%NoiseText='0dot002Noise'; Noise.power=[0.002]; 
%'0dot002NoiseGain5';%'0dot1Noise';%  '1Noise';%  '10Noise';%
Noise.sampling=Ts;
Noise.seed=[23341];

%% simulation
mysys='Simulation_Observer';
open_system(mysys);
set_param(mysys,'StartTime','ti','StopTime','tf');

%% Observer selection
 % 0 for Ménard 2010
Observer=0;
switch Observer
        case 0
        ObserverText='Menard2010theta89';
        % params_observer=[alpha;theta]
        alpha=0.9;%0.9
        theta=0.89;%5
        params_observer=[alpha;theta];
        set_param('Simulation_Observer/Observer','Parameters','params_observer','FunctionName','ThirdOrder_ObserverMenard2010');
        otherwise
        disp('Impossible');
end;  
out = sim(mysys, 'ReturnWorkspaceOutputs', 'on');
pause(3);
save_system(mysys);
close_system(mysys);

%% Plot / Affichage
pause(3);
Plot; 
