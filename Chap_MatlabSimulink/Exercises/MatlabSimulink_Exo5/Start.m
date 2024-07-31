%% Simulink parameters
ti=0;
mysimu='MySimulink';
open_system(mysimu);

%% Select system to simulate
mysys='InvertedPendulum';
% select system name in the list below
% 'BallBeam' \eqref{eq:BallBeam1}-\eqref{eq:BallBeam2} with $m=0.1\, [\unit{kg}], J=0.1\, [\unit{kg . m^2}]$,
% 'VolterraLotka' \eqref{eq:volterra} with $\alpha =\beta =\gamma=\delta =1$,
% 'VanderPol'  \eqref{eq:vdpForced} with $\mu=0.1$, or the Van der Pol equation \eqref{eq:vdpForced} with input ($A=1,\omega=10$),
% 'TwoCascadeTanks' \eqref{eq:2CascTanks} Figure \ref{fig:2cuvescascpst} with $S= 0.3512 \, [\unit{m^2}], \alpha_1= \alpha_2=0.0443$
% 'TwoTanks' \eqref{eq:TwoInterConnectTank1bis}-\eqref{eq:TwoInterConnectTank2bis} Figure \ref{fig:2cuvespst} with $S_1=1\, [\unit{m^2}], S_2=0.5\, [\unit{m^2}],  a_1=0.443,a_2=0.886$.
% 'ThreeTanks' \eqref{eq:3tanks1bis}-\eqref{eq:3tanks3bis} Figure \ref{fig:3tanks} with $S_1=1\, [\unit{m^2}], S_2=0.5\, [\unit{m^2}], S_3=1.3\, [\unit{m^2}], a_1=0.4429, a_2=a_3=0.8859$.
% 'Pendulum' \eqref{eq:ModelPendulum} with $g=9.81 \unit{\a}, \ell=1\, [\unit{\metre}], m=0.1\, [\unit{\kg}], \delta = 0.1\, [\unit{kg^{-1}.m^{-2}.s^{-1}}]$.
% 'InvertedPendulum'  Inverted Pendulum \eqref{eq:pendinvNL1}-\eqref{eq:pendinvNL4} with $M=2\, [\unit{kg}] ,m=0.1\, [\unit{kg}]  , \ell=0.5\, [\unit{m}], J=0.01\, [\unit{kg . m^2}], g=9.81 \, [\unit{m.s^{-2}}], F=1 \sin(10t) \, [\unit{N}].$
% 'MobileRobot30' type \eqref{eq:kinematic30},
% 'MobileRobot20' type \eqref{eq:kinematic20},
% 'MobileRobot21' type \eqref{eq:kinematic21},
% 'MobileRobot11' type \eqref{eq:kinematic11} with $L=2.5\, [\unit{m}]$,
% 'MobileRobot12' type \eqref{eq:kinematic12} with $L=2.5\, [\unit{m}]$,



% 'ChemicalReactor'
% 'Chua' \eqref{eq:Chua} with $C_1=C_2=10^{-10}\, [\unit{F}],R=2 \, [\unit{\ohm}], R_0=1\, [\unit{\ohm}]$,
% 'DCMotorDrone' \eqref{eq:DCMotorDrone1}-\eqref{eq:DCMotorDrone2} with $L=, R=, k= J_{tot}=,k_d=G=$,
% 'InductionMotor' \eqref{eq:InductionMotorAB} with ,
% '2DOF'  \eqref{eq:ModRoEuler} with parameters given by 


switch mysys 
    case 'BallBeam'
        tf=1;
        index_value=[1];
        Params= [0.1;0.1];%$m=0.1\, [\unit{kg}], J=0.1\, [\unit{kg . m^2}]$,
        set_param('MySimulink/Process','FunctionName','BallBeamSfunc');
	case 'VolterraLotka'
        tf=4;
        index_value=[1];
        Params=[1;1;1;1]; %$\alpha =\beta =\gamma=\delta =1$,
        set_param('MySimulink/Process','FunctionName','VolterraLotka');
    case 'VanderPol'
        tf=20;
        index_value=[1];
        Params=[0.1;1;10];%$\mu=0.1, A=1,\omega=10
        set_param('MySimulink/Process','FunctionName','VanderPol');
    case 'TwoCascadeTanks'
        tf=10;
        index_value=[1];
        Params=[0.3512;0.0443;0.0443];%S= 0.3512 \, [\unit{m^2}], \alpha_1= \alpha_2=0.0443$
        set_param('MySimulink/Process','FunctionName','TwoCascadeTanks');
    case 'TwoTanks'
        tf=20;
        index_value=[1 2];
        Params=[1;0.5;0.443;0.886];% S_1=1\, [\unit{m^2}], S_2=0.5\, [\unit{m^2}],  a_1=0.443,a_2=0.886$.
        set_param('MySimulink/Process','FunctionName','TwoTanks');
    case 'ThreeTanks'
        tf=20;
        index_value=[1 2];
        Params=[1;0.5;1.3;0.4429;0.8859;0.8859];%S_1=1\, [\unit{m^2}], S_2=0.5\, [\unit{m^2}], S_3=1.3\, [\unit{m^2}], a_1=0.4429, a_2=a_3=0.8859
        set_param('MySimulink/Process','FunctionName','ThreeTanks');
    case 'Pendulum' 
        tf=10;
        index_value=[1];
        Params=[1;0.1;0.1];%$g=9.81 \unit{\a}, \ell=1\, [\unit{\metre}], m=0.1\, [\unit{\kg}], \delta = 0.1\, [\unit{kg^{-1}.m^{-2}.s^{-1}}]$.
        set_param('MySimulink/Process','FunctionName','Pendulum');
     case 'InvertedPendulum' 
        tf=10;
        index_value=[1];
        Params=[2;0.1;0.5;1e-2;9.81];% M=2,m=0.1,l=0.5, J=0.01, g=9.81, F=1 \sin(10t)
        set_param('MySimulink/Process','FunctionName','InvertedPendulum');
    case 'MobileRobot30' 
        tf=10;
        index_value=[1 2 3];
        Params=[];% No params
        set_param('MySimulink/Process','FunctionName','MobileRobot30');
    case 'MobileRobot20' 
        tf=10;
        index_value=[1 2];
        Params=[];% No params
        set_param('MySimulink/Process','FunctionName','MobileRobot20');
    case 'MobileRobot21' 
        tf=10;
        Params=[];% No params
        set_param('MySimulink/Process','FunctionName','MobileRobot21');
    case 'MobileRobot11' 
        tf=10;
        Params=[2.5];% $L=2.5\, [\unit{m}]$,
        set_param('MySimulink/Process','FunctionName','MobileRobot11');
    case 'MobileRobot12' 
        tf=10;
        Params=[2.5];% $L=2.5\, [\unit{m}]$,
        set_param('MySimulink/Process','FunctionName','MobileRobot12');
    


    case 'ChemicalReactor'
        Params=[0.01;1;2;1;1;1;1;2];%$s= 0.01\, [\unit{m^2}]$, $n_A=1, n_B=2, n_C=1, k_1=k_2=1, c_{A0}=1, c_{B0}=2$,
        set_param('MySimulink/Process','FunctionName','ChemicalReactor');
    
    case 'Chua'
        set_param('MySimulink/Process','FunctionName','Chua');
    case 'DCMotorDrone'
        set_param('MySimulink/Process','FunctionName','DCMotorDrone');
    otherwise
        disp('Impossible');
end;

set_param('MySimulink/Process','Parameters','Params');
set_param(mysimu,'Solver','ode45','StartTime','ti','StopTime','tf'); 


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

