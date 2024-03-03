function y=MethodeEuler(t0,T,y0,h)
     t=[t0:h:T+t0];
     N=length(t);
     y=zeros(N,1);
     y(1)=y0;
     for k=1:N-1
         y(k+1)=y(k)+h*f(t(k),y(k));
     end
     plot(t,y);
     sol=y0*exp(t);
     hold on;plot(t,sol,'r');hold off;
     function z=f(t,y)
     z=y;