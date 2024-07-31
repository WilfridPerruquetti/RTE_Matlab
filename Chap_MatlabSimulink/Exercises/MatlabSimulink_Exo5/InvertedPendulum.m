function [sys,x0,str,ts] = InvertedPendulum(t,x,u,flag,Params)
m=Params(1);
J=Params(2);
g=9.81;
switch flag,
  case 0         % Initialization
    [sys,x0,str,ts] = mdlInitializeSizes;
  case 1
    sys = mdlDerivatives(t,x,u,Params); % Calculate derivatives
  case 3
    sys = mdlOutputs(t,x,u); % Calculate outputs
  case {2, 4, 9}
    sys = [];       % Unused flags
  otherwise
    error(['unhandled flag = ',num2str(flag)]); % Error handling
end

function [sys,x0,str,ts] = mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0.1;0;-0.1;0];
str = [];
ts  = [0, 0];

function sys = mdlDerivatives(t,x,u,Params)
M=Params(1);m=Params(2);l=Params(3);J=Params(4);g=Params(5);

%\dot z_1&=& z_2, \label{eq:pendinvNL1}\\
%\dot z_2&=& \frac{\left((J+m\ell^{2}) \left(F+m\ell{z_4}^{2}\sin(z_3)\right)-m^2g\ell^2 \sin(z_3)\cos(z_3)\right)}{M(J+m\ell^{2})+mJ+ m^2\ell^{2} (1-\cos^2(z_3))} ,\\
%\dot z_3&=& z_4,\\
%\dot z_4&=& \frac{\left(-m\ell\cos(z_3)  \left(F+m\ell{z_4}^{2}\sin(z_3)\right)+(M+m)mg\ell \sin(z_3)\right)}{M(J+m\ell^{2})+mJ+ m^2\ell^{2} (1-\cos^2(z_3))},\label{eq:pendinvNL4}
det=M*(J+m*l*l)+m*J+ m*m*l*l*(1-cos(x(3))*cos(x(3)));
a=(J+m*l*l);
b=u+m*l*x(4)*x(4)*sin(x(3));
c=(M+m);
d=m*l*cos(x(3));
e=m*g*l*sin(x(3));

sys(1) = x(2);
sys(2) = (a*b-d*e)/det;
sys(3) = x(4);
sys(4) = (-d*b+c*e)/det;

function sys = mdlOutputs(t,x,u)
sys=x;
