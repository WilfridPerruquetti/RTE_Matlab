%% Simulink parameters
ti=0;
tf=1;
mysimu='MySimulink';
open_system(mysimu);
set_param(mysimu,'Solver','ode45','StartTime','ti','StopTime','tf'); 

%% Select system to simulate
mysys='BallBeam';

% select system below
% 'BallBeam' 
% 'VolterraLotka' 
% 'ChemicalReactor'
% 'VanderPol'  \eqref{eq:vdpForced} with $\mu=0.1$, or the Van der Pol equation \eqref{eq:vdpForced} with input ($A=1,\omega=10$),
% 'Chua' \eqref{eq:Chua} with $C_1=C_2=10^{-10}\, [\unit{F}],R=2 \, [\unit{\ohm}], R_0=1\, [\unit{\ohm}]$,
% 'DCMotorDrone' \eqref{eq:DCMotorDrone1}-\eqref{eq:DCMotorDrone2} with $L=, R=, k= J_{tot}=,k_d=G=$,
% 'InductionMotor' \eqref{eq:InductionMotorAB} with ,
% 'InvertedPendulum' \eqref{eq:pendinvNL1}-\eqref{eq:pendinvNL2} with
% '2DOF'  \eqref{eq:ModRoEuler} with parameters given by 
% '30MobileRobot' type \eqref{eq:kinematic30},
% '20MobileRobot' type \eqref{eq:kinematic20},
% '21MobileRobot' type \eqref{eq:kinematic21},
% '11MobileRobot' type \eqref{eq:kinematic11} with $L=2.5\, [\unit{m}]$,
% '12MobileRobot' typ

switch mysys 
    case 'BallBeam'
        Params= [0.1;0.1];%$m=0.1\, [\unit{kg}], J=0.1\, [\unit{kg . m^2}]$,
        set_param('MySimulink/Process','FunctionName','BallBeamSfunc');
	case 'VolterraLotka'
        Params=[1;1;1;1]; %$\alpha =\beta =\gamma=\delta =1$,
        set_param('MySimulink/Process','FunctionName','Volterra-Lotka');
    case 'ChemicalReactor'
        Params=[0.01;1;2;1;1;1;1;2];%$s= 0.01\, [\unit{m^2}]$, $n_A=1, n_B=2, n_C=1, k_1=k_2=1, c_{A0}=1, c_{B0}=2$,
        set_param('MySimulink/Process','FunctionName','ChemicalReactor');
    case 'VanderPol'
        set_param('MySimulink/Process','FunctionName','VanderPol');
    case 'Chua'
        set_param('MySimulink/Process','FunctionName','Chua');
    case 'DCMotorDrone'
        set_param('MySimulink/Process','FunctionName','DCMotorDrone');
    otherwise
        disp('Impossible');
end;

set_param('MySimulink/Process','Parameters','Params');

%% Launch simu
out = sim(mysimu, 'ReturnWorkspaceOutputs', 'on');

pause(3); 

%% Affichage
%time
t=out.time;
% input
u=out.control;
% dim state
a=size(out.state);
% continuous state
figure('Name','Continuous state')
for i=1:a(2)
plot(t,out.state(:,i));
hold on;
end

title('Continuous state','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
ylabel('$x$','Interpreter','latex')

