clear all;
clc;
clear; clc; close all;

% Observed and fitted values
y = [10; 12; 14; 16; 18];
y_hat = [9.8; 11.5; 13.7; 15.6; 17.9];

% Residuals
e = y - y_hat;
i = 1:length(y);

% Residual plot
figure('Color','w');
stem(i, e, 'filled', 'LineWidth', 1.5);
hold on;
yline(0, '--k', 'LineWidth', 1.2);
grid on;
xlabel('Observation index');
ylabel('Residual e_i');
title('Residual plot for the illustrative regression example');
hold off;

saveas(gcf,'Figures/FigureResiduals.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters Figures/FigureResiduals

cleanfigure;
matlab2tikz('Figures/FigureResiduals.tex','width','\figwidth','height','\figheight','showInfo',false);