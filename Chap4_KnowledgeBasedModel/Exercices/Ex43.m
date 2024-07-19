m1=1;
m2=1;
k1=1;
k2=0.5;

D= [m1*m2 0 (m1*k2+m2*(k1+k2)) 0 k1*k2]

roots(D)

a=m1*m2;
b=(m1*k2+m2*(k1+k2));
c=k1*k2;
Delta=b^2-4*a*c

sol1=-(b+sqrt(Delta))/(2*a)
-(1+1/sqrt(2))
sol2=(-b+sqrt(Delta))/(2*a)
(-1+1/sqrt(2))

CheckDelta=m1^2*k2^2+m2^2*(k1+k2)^2+2*m1*k2*m2*(k2-k1)

% figure(1)
% plot(t,c)
% xlabel('$t\, [s]$','Interpreter','latex'), ylabel('$c(t)\, [kg\, l^{-1}]$','Interpreter','latex')
% legend({'Solution $c(t)=\frac{a}{b} (1-\exp(-bt))+c(0)\exp(-bt)$'},'interpreter','latex','Location','southwest')
% 
% %saveas(gcf,'Figures/FigureEx42_1.pdf')
% set(gcf,'Units','centimeters');
% screenposition = get(gcf,'Position');
% set(gcf,...
%     'PaperPosition',[0 0 screenposition(3:4)],...
%     'PaperSize',[screenposition(3:4)]);
% print -dpdf -painters Figures/FigureEx42_1
% 
% % cleanfigure;
% % matlab2tikz('Figures/FigureEx42_1.tex','width','\figwidth','height','\figheight','showInfo',false);
% 
% 
