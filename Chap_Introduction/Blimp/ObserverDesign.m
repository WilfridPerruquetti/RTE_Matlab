clear all;
clc;
%% Blimp parameters
%% 11 when \dot{z}<0 & u_z<0
a(1,1)=-0.28412;
b(1,1)=0.11214;
%% 12 when \dot{z}<0 & u_z>0
a(1,2)=-0.28412;
b(1,2)=0.06149;
%% 21 when \dot{z}>0 & u_z<0
a(2,1)=-0.34316;
b(2,1)=0.11214;
%% 22 when \dot{z}>0 & u_z>0
a(2,2)=-0.34316;
b(2,2)=0.06149;
%% Blimp state representation
Ab11=[0 1;0 a(1,1)];
Ab12=[0 1;0 a(1,2)];
Ab21=[0 1;0 a(2,1)];
Ab22=[0 1;0 a(2,2)];

B11=[0;b(1,1)];
B12=[0;b(1,2)];
B21=[0;b(2,1)];
B22=[0;b(2,2)];

C=[1 0];
D=[0];
%% Observer specifications
Observer.z=2;
Observer.tr=5;
% In order to select zeta: 0.7<zeta<1 eventually > 1 (for observer) in that case gives poles directly it is easier !
% if 0.4 <zeta<0.7 then tr=5/wn; 
% if zeta =0.7 then tr=2.9/wn 
% if zeta<1 then tr=4.3*zeta/wn
% if zeta > 1.5 tr=6*zeta/wn ....
for i=1:2
    for j=1:2
        Acomp=A;
        % Computation of the characteristic polynomial of A
        PolyCarac=poly(A);
        a0=PolyCarac(3);
        a1=PolyCarac(2);
        % poles selection
        Observer.wn=6*Observer.z/Observer.tr;
        Observer.poly2=[1 2*Observer.z*Observer.wn Observer.wn*Observer.wn];
        Observer.poles=roots(Observer.poly2);
        % Observer gain
        L=place(A',C',Observer.poles)';
        % state space matrices for the observer implementation in simulink
        A_Obs(ij)=A;
        B_Obs(ij)=[B(ij) L];
    end;
end;

C_Obs=eye(2);
D_Obs=[0 0;0 0];






