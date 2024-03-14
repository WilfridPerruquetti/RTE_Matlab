function  [sys, x0]  = ParamEstim(t,x,u,flag)
% \int_0^t \int_0^v s^\ell  u(s) dsdv => 2 state variables*2 (ell1 and ell2)= 4;

%\int_0^t \int_0^v s^\ell \dot \theta(s) dsdv
%=\int_0^t v^\ell \theta(v) dv
%-\ell \int_0^t \int_0^v s^{\ell-1}\theta(s) dsdv,
% => (1+2)*2= 6 state variables

%\int_0^t \int_0^v s^\ell \ddot \theta(s) dsdv
% = t^\ell \theta(t)
%-2 \ell \int_0^t s^{\ell-1}\theta(s) ds
% + \ell (\ell -1) \int_0^t \int_0^vs^{\ell-2}\theta(s) dsdv
% => (1+2)*2= 6 state variables

ell2=4;
ell3=5;
if flag == 1 % Return state derivatives, xDot
    theta=u(1);
    v=u(2);
    % 5 state variables for int on input
    sys(1,1)= x(2);
    sys(2,1)= t^(ell2)*v;
    sys(3,1)= x(4);
    sys(4,1)= t^(ell3)*v;
    % 6 state variables for int int dot \theta
    sys(5,1)= t^(ell2)*theta;
    sys(6,1)= x(7);
    sys(7,1)= t^(ell2-1)*theta;
    sys(8,1)= t^(ell3)*theta;
    sys(9,1)= x(10);
    sys(10,1)= t^(ell3-1)*theta;
    % 6 state variables for int int ddot \theta
    sys(11,1)= t^(ell2-1)*theta;
    sys(12,1)= x(13);
    sys(13,1)= t^(ell2-2)*theta;
    sys(14,1)= t^(ell3-1)*theta;
    sys(15,1)= x(16);
    sys(16,1)= t^(ell3-2)*theta;
elseif flag == 3 % Return system outputs, y
    theta=u(1);
    v=u(2);
    % A B Computation
    A2= t^(ell2)*theta-2*ell2*x(11)+ell2*(ell2-1)*x(12);
    A3= t^(ell3)*theta-2*ell3*x(14)+ell3*(ell3-1)*x(15);
    B2=x(1);
    B3=x(3);
    C2=x(5)-ell2*x(6);
    C3=x(8)-ell3*x(9);
    % M Computation
    M=[A2 -B2;
       A3 -B3];
    B=[-C2;-C3];
    % tau k
    Res=pinv(M)*B;
    sys(1,1) = Res(1);
	sys(2,1) = Res(2);

elseif flag == 0 % Return sizes and x0
   %sys = [continuous state numb; discrete state numb; output numb; input numb;0; 0]; 
    sys = [16; 0; 2; 2; 1; 1];  
    x0 = zeros(16,1);

else 
    % If flag is anything else, no need to return anything
    sys = [];
end
