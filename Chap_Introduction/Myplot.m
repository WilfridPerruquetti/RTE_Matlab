%% Plot / Affichage
t=out.time;
l=length(t);

x1=out.state(:,1);
x2=out.state(:,2);
x3=out.state(:,3);

%equilibre
eq=x1(l);
for i=1:size(x1), normx(i)=sqrt((x1(i)-eq)^2+(x2(i)-eq)^2+(x3(i)-eq)^2); end;
lognormx=log(normx');
u1=out.control(:,1);
u2=out.control(:,2);


marge=0;


finsimu=l-marge;

figure(1)
plot(t(1:finsimu),x1(1:finsimu),t(1:finsimu),x2(1:finsimu),t(1:finsimu),x3(1:finsimu))
xlabel('$t$','Interpreter','latex')
ylabel('$h_1,h_2,h_3$','Interpreter','latex')
legend('$h_1(t)$','$h_2(t)$','$h_3(t)$','Interpreter','latex')
%saveas(gcf,'Figure1.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure1

cleanfigure;
matlab2tikz('Figures/Figure1.tex','width','\figwidth','height','\figheight','showInfo',false);


figure(2)
plot(t(1:finsimu),lognormx(1:finsimu))
xlabel('$t$','Interpreter','latex')
ylabel('$\log(\vert x-x_{eq}\vert)$','Interpreter','latex')
legend('$\log(\vert x(t)-x_{eq} \vert)$','Interpreter','latex')
%saveas(gcf,'Figure2.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure2

cleanfigure;
matlab2tikz('Figures/Figure2.tex','width','\figwidth','height','\figheight','showInfo',false);

figure(3)
plot(t(1:finsimu),u1(1:finsimu),t(1:finsimu),u2(1:finsimu))
xlabel('$t$','Interpreter','latex')
ylabel('$q_e$','Interpreter','latex')
legend('$q_{e1}(t)$','$q_{e2}(t)$','Interpreter','latex')
%saveas(gcf,'Figure3.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/Figure3

cleanfigure;
matlab2tikz('Figures/Figure3.tex','width','\figwidth','height','\figheight','showInfo',false);



