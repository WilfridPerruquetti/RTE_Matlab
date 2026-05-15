clear; clc; close all;

set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

caseName = 'ObsAlgLin3';
polesObs = [-4 -5];
a1obs = -sum(polesObs);
a0obs = prod(polesObs);

sys = getExerciseSystem(caseName);
A = sys.A; B = sys.B; C = sys.C;

fprintf('\n=== %s ===\n', sys.name);
disp('A ='); disp(A);
disp('B ='); disp(B);
disp('C ='); disp(C);

if rank(obsv(A,C)) < size(A,1)
    error('The pair (A,C) is not observable/detectable for full-order design.');
end

L_place = place(A',C',polesObs)';
disp('Gain from place(A'',C'',polesObs)'':');
disp(L_place);

L_hand = [];
if size(A,1)==2 && isequal(C,[1 0])
    a11 = A(1,1); a12 = A(1,2); a21 = A(2,1); a22 = A(2,2);
    l1 = a1obs + a11 + a22;
    l2 = (a0obs - a11*a22 + l1*a22 + a12*a21)/a12;
    L_hand = [l1; l2];
elseif size(A,1)==2 && isequal(C,[0 1])
    a11 = A(1,1); a12 = A(1,2); a21 = A(2,1); a22 = A(2,2);
    l2 = a1obs + a11 + a22;
    l1 = (a0obs - a11*a22 + a11*l2 + a21*a12)/a21;
    L_hand = [l1; l2];
end

if ~isempty(L_hand)
    disp('Gain from explicit hand formula:');
    disp(L_hand);
    disp('Difference L_place - L_hand =');
    disp(L_place - L_hand);
end

Tend = 8;
dt = 1e-3;
t = 0:dt:Tend;

n = size(A,1);
p = size(C,1);
x = sys.x0;
xhat = zeros(n,1);
X = zeros(n,length(t));
Xhat = zeros(n,length(t));
Y = zeros(p,length(t));

for k = 1:length(t)
    tk = t(k);
    u = sys.inputFcn(tk);
    y = C*x;

    X(:,k) = x;
    Xhat(:,k) = xhat;
    Y(:,k) = y;

    if k < length(t)
        xdot = A*x + B*u;
        xhatdot = A*xhat + B*u + L_place*(y - C*xhat);
        x = x + dt*xdot;
        xhat = xhat + dt*xhatdot;
    end
end

figure;
for i = 1:n
    subplot(n,1,i);
    plot(t,X(i,:), 'LineWidth',1.2); hold on;
    plot(t,Xhat(i,:),'--','LineWidth',1.2);
    grid on;
    legend(sprintf('x_%d',i),sprintf('xhat_%d',i),'Location','best');
end
sgtitle(['Observer simulation: ', sys.name]);

function sys = getExerciseSystem(caseName)
    switch caseName
        case 'ObsAlgLin1'
            b = 1;
            sys.name = 'Exercise ObsAlgLin1';
            sys.A = [1 1; 0 0];
            sys.B = [0; b];
            sys.C = [1 0];
            sys.x0 = [1; -0.5];
            sys.inputFcn = @(t) sin(t);
        case 'ObsAlgLin2'
            m = 1; alpha = 0.8; k = 2;
            sys.name = 'Exercise ObsAlgLin2';
            sys.A = [0 1; -k/m -alpha/m];
            sys.B = [0; 0];
            sys.C = [1 0];
            sys.x0 = [1; 0];
            sys.inputFcn = @(t) 0;
        case 'ObsAlgLin3'
            m = 1; ell = 1; g = 9.81; delta = 0.4;
            sys.name = 'Exercise ObsAlgLin3';
            sys.A = [0 1; -g/ell -delta/(m*ell^2)];
            sys.B = [0; 1/(m*ell^2)];
            sys.C = [1 0];
            sys.x0 = [0.3; 0];
            sys.inputFcn = @(t) 0.2*sin(t);
        case 'ObsAlgLin4'
            omega_n = 3; zeta = 0.2;
            sys.name = 'Exercise ObsAlgLin4';
            sys.A = [0 1; -omega_n^2 -2*zeta*omega_n];
            sys.B = [0; 1];
            sys.C = [1 0];
            sys.x0 = [0.5; 0];
            sys.inputFcn = @(t) sin(2*t);
        case 'ObsAlgLin5'
            s = 0.5; g = 9.81; S = 1.2; he = 1; a = 0.8; b = 0.6; Jm = 0.7; c = 1;
            ah = s*sqrt(g)/(S*sqrt(2*he));
            gamma = a/S;
            sys.name = 'Exercise ObsAlgLin5';
            sys.A = [-ah gamma; 0 -b/Jm];
            sys.B = [0; c/Jm];
            sys.C = [1 0];
            sys.x0 = [0.2; -0.1];
            sys.inputFcn = @(t) 0.1*cos(t);
        case 'ObsAlgLin6'
            a1 = 1.5; a2 = 0.7; b = 1;
            sys.name = 'Exercise ObsAlgLin6 (observable case y=z2)';
            sys.A = [-a1 0; a1 -a2];
            sys.B = [b; 0];
            sys.C = [0 1];
            sys.x0 = [0.4; 0];
            sys.inputFcn = @(t) 0.2*sin(t);
        case 'ObsGeomMetronome'
            J = 0.08; K = 0.5;
            sys.name = 'Exercise ObsGeomMetronome';
            sys.A = [0 1; -K/J 0];
            sys.B = [0; 0];
            sys.C = [1 0];
            sys.x0 = [0.2; 0];
            sys.inputFcn = @(t) 0;
        case 'ObsGeomDrone_z1'
            R = 1; Le = 0.5; k = 0.8; Jtot = 0.9; kd = 0.03; weq = 20; G = 1;
            d = 2*kd*weq/(G^2*Jtot);
            sys.name = 'Exercise ObsGeomDrone with y=z1';
            sys.A = [-R/Le -k/Le; k/Jtot -d];
            sys.B = [1/Le; 0];
            sys.C = [1 0];
            sys.x0 = [0.3; 0];
            sys.inputFcn = @(t) 0.5 + 0.1*sin(t);
        case 'ObsGeomDrone_z2'
            R = 1; Le = 0.5; k = 0.8; Jtot = 0.9; kd = 0.03; weq = 20; G = 1;
            d = 2*kd*weq/(G^2*Jtot);
            sys.name = 'Exercise ObsGeomDrone with y=z2';
            sys.A = [-R/Le -k/Le; k/Jtot -d];
            sys.B = [1/Le; 0];
            sys.C = [0 1];
            sys.x0 = [0.3; 0];
            sys.inputFcn = @(t) 0.5 + 0.1*sin(t);
        otherwise
            error('Unknown case name.');
    end
end
			