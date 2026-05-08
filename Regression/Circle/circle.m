clc;
clear all;
close all;
load('datacircle.mat');

% Build the least-squares problem
z = x.^2 + y.^2;
C = [2*x, 2*y, ones(length(x),1)];
[n,p] = size(C);

% Least-squares solution
theta = C \ z;
a = theta(1);
b = theta(2);
c = theta(3);
R = sqrt(c + a^2 + b^2);

% using fitlm
model=fitlm(C,z);

intercept=model.Coefficients.Estimate(1,1);
ap=model.Coefficients.Estimate(2,1)
bp=model.Coefficients.Estimate(3,1)
Rp=sqrt(intercept+ap^2+bp^2)

% Plot fitted circle
figure(1);
t=linspace(0,2*pi,100);
plot(x,y,"o",a+R*cos(t),b+R*sin(t),"-")
xlim([-5 3])
ylim([-2 6])
grid on
daspect([1 1 1])
legend({'Data','$(x-a)^2+(y-b)^2=R^2$'},'interpreter','latex','Location','southwest')
title('Circle fit');

% save Figure 1
saveas(gcf,'FigureCircle.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureCircle

cleanfigure;
matlab2tikz('FigureCircle.tex','width','\figwidth','height','\figheight','showInfo',false);


% Linear model used for statistical analysis
model;
anova_table = anova(model,'summary');
coef_table = model.Coefficients;

% Fitted values and residuals
z_hat = model.Fitted;
e = model.Residuals.Raw;

% Performance indicators
SSE = sum(e.^2);
MSE = SSE / n;
s2 = SSE / (n - p);
RMSE = sqrt(s2);
SST = sum((z - mean(z)).^2);
R2 = 1 - SSE / SST;
adjR2 = 1 - (SSE/(n-p)) / (SST/(n-1));

% Hat matrix and leverage
H = C * ((C' * C) \ C');
h = diag(H);

% Standardized residuals and Cook's distances
r = zeros(n,1);
D = zeros(n,1);
for i = 1:n
    r(i) = e(i) / sqrt(s2 * (1 - h(i)));
    D(i) = (e(i)^2 / (p * s2)) * (h(i) / (1 - h(i))^2);
end

% Summary table
summary_table = table((1:n)', x, y, z, z_hat, e, h, r, D, ...
    'VariableNames', {'Obs','x','y','z','z_hat','Residual', ...
    'Leverage','StdResidual','CooksDistance'});

% Sort the most atypical observations
[~, idx_cook] = sort(D, 'descend');
[~, idx_res] = sort(abs(r), 'descend');
top_cook = summary_table(idx_cook(1:10), :);
top_res = summary_table(idx_res(1:10), :);

% Display results
fprintf('a = %.6f\n', a);
fprintf('b = %.6f\n', b);
fprintf('R = %.6f\n', R);

fprintf('SSE   = %.6f\n', SSE);
fprintf('MSE   = %.6f\n', MSE);
fprintf('s^2   = %.6f\n', s2);
fprintf('RMSE  = %.6f\n', RMSE);
fprintf('R^2   = %.6f\n', R2);
fprintf('AdjR2 = %.6f\n', adjR2);

disp(coef_table);
disp(anova_table);
disp(summary_table(1:10,:));
disp(top_cook);
disp(top_res);

if max(abs(r)) < 2
    fprintf('No standardized residual exceeds |2|.\n');
else
    fprintf('A few observations deserve attention in the residual analysis.\n');
end

if max(D) < 1
    fprintf('No observation appears strongly influential under the D_i > 1 rule.\n');
else
    fprintf('At least one observation appears influential.\n');
end



% Residual plot
figure(2);
plot(z_hat,e,'o','LineWidth',1,'MarkerSize',7);
grid on;
xlabel('Fitted values');
ylabel('Residuals');
title('Residuals versus fitted values');
yline(0,'--k');


% save Figure 2
saveas(gcf,'FigureResiduals.pdf')
set(gcf,'Units','centimeters');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print -dpdf -painters FigureResiduals

cleanfigure;
matlab2tikz('FigureResiduals.tex','width','\figwidth','height','\figheight','showInfo',false);
