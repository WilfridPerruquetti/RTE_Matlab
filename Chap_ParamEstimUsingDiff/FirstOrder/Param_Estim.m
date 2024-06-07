function  [sys, x0]  = Param_Estim(t,x,e,flag)

if flag==1
   sys(1,1)=0;
elseif flag == 3
    y=e(1) 
    doty=e(2);
    ddoty=e(3);
    u=e(4);
    dotu=e(5);
% A=[-y u;-doty dotu];
% b=[doty;ddoty];
% det(A)
% if isfinite(det(A))
%     sys=[1;2];%pinv(A)*b;
% else 
%     sys=[0;0];
% end;
sys=[1;1];%y;doty];
elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [1; 0; 2; 5; 0; 0];
    x0=[0];
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
