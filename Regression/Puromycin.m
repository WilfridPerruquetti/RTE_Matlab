clear all;
clc;
% read data
T = readtable('Puromycin.csv');
conct=table2array(T(2:12,2));
ratet=table2array(T(2:12,3));
concu=table2array(T(13:23,2));
rateu=table2array(T(13:23,3));
figure(1)
scatter(conct,ratet,'c','red',"filled");
hold on;
scatter(concu,rateu,'d','magenta',"filled");
xlabel('Concentration [ppm]','interpreter','latex') % 
ylabel('Velocity c min$^{-1}$','interpreter','latex')
hold on;
t=0:0.03:1.2;
% theta1est=260;
% theta2est=0.2;
% y=(theta1est.*t)./(theta2est+t);
% plot(t,y,'blue')

% Nonlinear fit
modelfun = @(param,x)(param(1)*x./(param(2)+x));
[param,r,j] = nlinfit(conct,ratet,modelfun,[260;0.2]);
theta1t = param(1);
theta2t = param(2);
yt=(theta1t.*t)./(theta2t+t);

[param,r,j] = nlinfit(concu,rateu,modelfun,[260;0.2]);
theta1u = param(1);
theta2u = param(2);
yu=(theta1u.*t)./(theta2u+t);

plot(t,yt,'red',t,yu,'magenta')
legend({'Data enzyme treated','Data enzyme untreated','$y=\frac{\theta_1 x}{\theta_2+x}, \theta_1=216,62, \theta_2=0.0722$', 'id. with $\theta_1=160.28, \theta_2=0.0477$'},'interpreter','latex','Location','southeast')

saveas(gcf,'Figures/FigurePuromycin.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigurePuromycin

cleanfigure;
matlab2tikz('Figures/FigurePuromycin.tex','width','\figwidth','height','\figheight','showInfo',false);