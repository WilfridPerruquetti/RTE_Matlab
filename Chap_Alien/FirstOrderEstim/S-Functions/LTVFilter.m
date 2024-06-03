function  [sys, x0]  = LTVFilter(t,z,v,flag)
% n(t)&=& 2x_1+x_2-x_3-x_4,\\
% \ddot x_1&=& y(t),\\
% \dot x_2&=& ty(t),\\
% \ddot x_3&=& tu(t),\\
% x_4^{(3)}&=&u(t),\\
% d(t)&=&x_5+x_6, \\
% \ddot x_5&=&t y(t),\\
% x_6^{(3)}&=&y(t).

if  flag == 1 % derivative 
    u=v(1);
    y=v(2);
    
    sys(1,1)=z(2);
    sys(2,1)=y; % z(1) => x_1
    sys(3,1)=t*y; % z(3) => x_2
    sys(4,1)=z(5);
    sys(5,1)=t*u; % z(4) => x_3
    sys(6,1)=z(7);
    sys(7,1)=z(8);
    sys(8,1)=u; % z(6) => x_4
    sys(9,1)=z(10);
    sys(10,1)=t*y; % z(9) => x_5
    sys(11,1)=z(12);
    sys(12,1)=z(13);
    sys(13,1)=y; % z(11) => x_6
    
elseif flag == 3
    num=2*z(1)+z(3)-z(4)-z(6)
    den=z(9)+z(11);
    res=num/den;
    if isnan(res)
        sys(1,1)=0; 
    else
        if abs(res) <10
        sys(1,1)=-res;
        else end;
    end;
elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [13; 0; 1; 2; 0; 0]; 
    x0 = zeros(13,1);
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
