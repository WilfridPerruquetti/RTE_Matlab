function [sys,x0,str,ts] = PredatorPreyModel(t,x,u,flag,Params)
dperiod = 0.5;
doffset = 0;

switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes(dperiod,doffset);
  case 2
    sys = mdlUpdate(t,x,u,Params); % Update disc states
  case 3
    sys = mdlOutputs(t,x,u); % Calculate outputs
  case {1, 4, 9}
    sys = [];       % Unused flags
  otherwise
    error(['unhandled flag = ',num2str(flag)]); % Error handling
end

function [sys,x0,str,ts] = mdlInitializeSizes(dperiod,doffset)
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 3;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [10;4;2];
str = [];
ts  = [dperiod, doffset];

function sys = mdlUpdate(t,x,u,Params)
%x_{n+1} = x_n + r_x x_n \left(1 - \frac{x_n}{K_x}\right) - a_{xy} x_n y_n \\
%y_{n+1} = y_n + r_y y_n \left(1 - \frac{y_n}{K_y}\right) + a_{xy} b_{xy} x_n y_n - a_{yz} y_n z_n \\
%z_{n+1} = z_n + r_z z_n \left(1 - \frac{z_n}{K_z}\right) + a_{yz} b_{yz} y_n z_n
%r_x=10,r_y=3, r_z=1.5,$ $K_x=, K_y=, K_z=, a_{xy}=, a_{yz}= , b_{xy}= ,b_{yz}
rx=Params(1);
ry=Params(2);
rz=Params(3);
Kx=Params(4);
Ky=Params(5);
Kz=Params(6);
axy=Params(7);
ayz=Params(8);
bxy=Params(9);
byz=Params(10);

xn=x(1);
yn=x(2);
zn=x(3);

sys(1,1) = xn + rx*xn*(1 - xn/Kx) - axy*xn*yn;
sys(2,1) = yn + ry*yn*(1 - yn/Ky) + axy*bxy*xn*yn - ayz*yn*zn;
sys(3,1) = zn + rz*zn*(1 - zn/Kz) + ayz*byz*yn*zn;

function sys = mdlOutputs(t,x,u)
for i=1:3
  sys(i,1) = x(i); 
end;
