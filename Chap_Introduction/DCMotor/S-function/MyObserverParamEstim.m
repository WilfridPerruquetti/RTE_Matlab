function  [sys, x0]  = MyObserverParamEstim(t,x,u,flag)
N=100; % nombre de points pour l'intégration
if flag == 1
    % If flag = 1, return state derivatives, xDot
    v=u(1);
    y=u(2);
    theta=10;
    s=15;
    l1=1*s;
    l2=2*s;
    l3=1*s;
    v(1)=y;
    v(2)=x(2)-l1*theta^(1/3)*sign(x(1)-v(1))*abs(x(1)-v(1))^(2/3);
    sys(1,1)=v(2);
    v(3)=x(3)-l2*theta^(1/2)*sign(x(2)-v(2))*abs(x(2)-v(2))^(1/2);
    sys(2,1)=v(3);
    sys(3,1)=-l3*theta*sign(x(3)-v(3));
elseif flag == 2
    %int
    v=u(1);
    y=u(2);
elseif flag == 3
    % If flag = 3, return system outputs, y
    sys(1,1)= x(1);
    sys(2,1)= x(2);
elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    sys = [3; 0; 2; 2; 0; 0];
    x0 = zeros(3,1);
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end

