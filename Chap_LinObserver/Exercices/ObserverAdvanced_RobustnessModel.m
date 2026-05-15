set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

gamma0 = 2.5;      % nominal g/ell
damp   = 0.3;      % delta/(m ell^2)
C = [1 0];
polesObs = [-2 -3];

A0 = [0 1; -gamma0 -damp];
L = place(A0',C',polesObs)';

gamma = linspace(0.8*gamma0,1.2*gamma0,100);
lambda = zeros(2,numel(gamma));
for k = 1:numel(gamma)
    Atrue = [0 1; -gamma(k) -damp];
    lambda(:,k) = eig(Atrue - L*C);
end

figure; plot(real(lambda.'),imag(lambda.'),'LineWidth',1.5);
xlabel('Real part'); ylabel('Imaginary part'); grid on;
title('Observer eigenvalue locus under parameter uncertainty');


exportgraphics(gcf, 'FigureRobustParamVar.pdf', 'ContentType', 'vector');