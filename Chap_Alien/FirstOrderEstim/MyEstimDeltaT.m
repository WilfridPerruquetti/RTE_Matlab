function  [sys, x0]  = MyEstimDeltaT(t,x,u,flag,NWindow,Ts,P,Q)
if  flag == 2
    % u(1)=u stocké dans x(1) à x(Nwindow)
    % u(2)=y stocké dans x(Nwindow+1) à x(2Nwindow)
    for i=1:NWindow-1
        sys(i,1)=x(i+1);
        sys(NWindow+i,1)=x(NWindow+i+1);
    end;
        sys(NWindow,1)=u(1);
        sys(2*NWindow,1)=u(2); 
elseif flag == 3
    if t<=10*Ts
        sys(1,1)=0;
    else
    int1=0;
    int2=0;
    
    % new time for int from t-Nwindow*Ts to t
    tau=t-NWindow*Ts:Ts:t;
    NewTau1=tau/t;
    NewTau2=tau/(t-NWindow*Ts);

    %P degrès 3
    PolyP1=P(1).*NewTau1.*NewTau1+P(2).*NewTau1+P(3);
    PolyP2=P(1).*NewTau2.*NewTau2+P(2).*NewTau2+P(3);
    %Q degrès 2
    PolyQ1=Q(1).*NewTau1+Q(2);
    PolyQ2=Q(1).*NewTau2+Q(2);
    
    for i=1:NWindow 
         y=x(NWindow+i);
         u=x(i);
         f1= (PolyQ1(i)-PolyQ2(i))*y-(t*PolyP1(i)-(t-NWindow*Ts)*PolyP2(i))*u;
         f2= (t*PolyP1(i)-(t-NWindow*Ts)*PolyP2(i))*y;
         int1=int1+Ts*f1;
         int2=int2+Ts*f2;
    end;
    res=int1/(int2);
    if isnan(res)
        sys(1,1)=0; 
    else
        sys(1,1)=-res;
    end;
    end;
elseif flag == 0
    % If flag = 0, return initial condition data, sizes and x0
    %sys = [nb d'états continus; nb d'états discrets; nb de sorties; nb d'entrées;0; 0]; 
    sys = [0; 2*NWindow; 1; 2; 0; 0]; 
    x0 = zeros(2*NWindow,1);
else
    % If flag is anything else, no need to return anything since this is a continuous system
    sys = [];
end
