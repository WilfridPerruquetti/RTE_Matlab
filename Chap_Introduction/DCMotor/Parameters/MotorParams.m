%%%%%%%%%%%%%%%%%%%%%%
%% Motor Parameters %%
%%%%%%%%%%%%%%%%%%%%%%
% Nominal parameters are 
R_nominal=2;   % Motor resistance
L_nominal=5*1e-4 ; % Motor inductance
ke_nominal=1*1e-2;   % Electric/Mechanic motor constant
b_nominal=0.008;        % Viscous friction
Jtot_nominal=6*1e-5;
umax=12; %maximal voltage (set to 12 V)

tau_nominal=Jtot_nominal/(b_nominal+ke_nominal*ke_nominal/R_nominal);
k_nominal=ke_nominal/(R_nominal*(b_nominal+ke_nominal*ke_nominal/R_nominal));
kc_nominal=1/(b_nominal+ke_nominal*ke_nominal/R_nominal);
% Real parameters
R=R_nominal*(1+error);
L=L_nominal*(1+error);
ke=ke_nominal*(1+error);
b=b_nominal*(1+error);
Jtot=Jtot_nominal*(1+error);
tau=tau_nominal*(1+error);
k=k_nominal*(1+error);
kc=kc_nominal*(1+error);

% Complete model (theta, \dot \theta,i) angular position, angular speed and
% current
params_nominal=[R_nominal;L_nominal;ke_nominal;b_nominal;Jtot_nominal;umax];
params_real=[R;L;ke;b;Jtot;umax];
A_nominal=[0 1 0;
    0 -b_nominal/Jtot_nominal ke_nominal/Jtot_nominal;
    0 -ke_nominal/L_nominal -R_nominal/L_nominal];
B_nominal=[0;0;1/L_nominal];
C_nominal=[1 0 0];
D_nominal=0;
Cx_nominal=eye(3);
Dx_nominal=[0;0;0];
D_Load=[0;0;0];
A_real=[0 1 0;
    0 -b/Jtot ke/Jtot;
    0 -ke/L -R/L];
B_real=[0;0;1/L];
B_Load=[0;-1/Jtot;0];
IC.state=[IC.thetar;IC.omegar;IC.ir];

B_real=[B_real';B_Load']';
Cx_real=Cx_nominal;
Dx_real=[Dx_nominal'; D_Load']';

SS_nominal=ss(A_nominal,B_nominal,C_nominal,D_nominal);
display(SS_nominal);




