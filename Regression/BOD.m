clear all;
clc;
% read data
Time =[1;2;3;4;5;7]
Demand=[8.3;10.3;19.0;16.0;15.6;19.8]
figure(1)
scatter(Time,Demand)
xlabel('Days','interpreter','latex')
ylabel('Oxygen demand','interpreter','latex')
hold on;
t=0:0.1:7;
% theta1est=20;
% theta2est=0.6;
% y=theta1est*(1-exp(-theta2est.*t));
% plot(t,y,'blue')


modelfun = @(param,x)(param(1)*(1-exp(-param(2)*x)));

% Nonlinear fit
[param,r,j] = nlinfit(Time,Demand,modelfun,[20;0.6]);
theta1 = param(1);
theta2 = param(2);
y1=theta1*(1-exp(-theta2.*t));
plot(t,y1,'red')
legend({'Data','$y=\theta_1 (1-\exp(-\theta_2 x)), \theta_1=19.142, \theta_2=0.531$'},'interpreter','latex','Location','southeast')

saveas(gcf,'Figures/FigureBOD.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureBOD

cleanfigure;
matlab2tikz('Figures/FigureBOD.tex','width','\figwidth','height','\figheight','showInfo',false);