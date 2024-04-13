% calcul de la relation entre temps de réponse
% à 5 % et l'amortissement réduit
t=0:.1:700;
tr5=[ ];
absc=logspace(-2,2,1000);
for i = absc, 
   [num,den]=ord2(1,i);
   y=step(tf(num,den),t);
   in=find(abs(y-ones(size(t')))>.05);
   tr5= [tr5 max(in)];
end;
% figure(1)
% semilogx(absc,.1*tr5)
% grid
% xlabel('$\zeta$','interpreter','latex')
% ylabel('$\omega_n \times t_r$','interpreter','latex')

figure(2)
loglog(absc,.1*tr5,'c','HandleVisibility', 'off')
hold on;
% if 0.43 <zeta<0.69 then tr=5.3/wn;
x=0.43:0.01:0.69;
y=5.3*ones(size(x'));
plot(x,y,'m--');
% if zeta =0.7 then tr=2.9/wn 
% if zeta<1 then tr=4.3*zeta/wn
x=0.69:0.01:1;
y=4.3*x;
plot(x,y,'m--');
% if zeta > 1.5 tr=6*zeta/wn ..
x=1.5:0.01:20;
y=6*x;
plot(x,y,'m--');


grid
xlabel('$\zeta$','interpreter','latex')
ylabel('$\omega_n \times t_r$','interpreter','latex')
hLeg = legend('example')
set(hLeg,'visible','off')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Abaque

cleanfigure;
matlab2tikz('Abaque.tex','width','\figwidth','height','\figheight','showInfo',false);

