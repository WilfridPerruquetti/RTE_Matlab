% Sequential modal approximation vs System Identification Toolbox
clear; clc; close all;

%% 1. Génération des données
Ts = 0.05;
t  = (0:400)'*Ts;
% Système original : y(t) = 2 - 1.2*exp(-0.5*t) - 0.5*exp(-2*t) - 0.2*exp(-8*t)
y_clean = 2 - 1.2*exp(-0.5*t) - 0.5*exp(-2*t) - 0.2*exp(-8*t);
y = y_clean + 0.01*randn(size(y_clean));

%% 2. Identification Séquentielle (Peeling Method)
% Estimation de la valeur finale (Steady State)
yss_est = mean(y(end-20:end));
r0 = y - yss_est;

% Mode lent (lambda=0.5) - Fenêtre où les modes rapides ont disparu
I1 = 150:350; 
p1 = polyfit(t(I1), log(abs(r0(I1))), 1);
lambda1 = -p1(1);
c1 = sign(mean(r0(I1))) * exp(p1(2));
r1 = r0 - c1*exp(-lambda1*t);

% Mode intermédiaire (lambda=2) - Fenêtre médiane
I2 = 30:70;
p2 = polyfit(t(I2), log(abs(r1(I2))), 1);
lambda2 = -p2(1);
c2 = sign(mean(r1(I2))) * exp(p2(2));
r2 = r1 - c2*exp(-lambda2*t);

% Mode rapide (lambda=8) - Début de courbe
I3 = 1:15;
p3 = polyfit(t(I3), log(abs(r2(I3))), 1);
lambda3 = -p3(1);
c3 = sign(mean(r2(I3))) * exp(p3(2));

% Reconstruction du modèle séquentiel
y_seq = yss_est + c1*exp(-lambda1*t) + c2*exp(-lambda2*t) + c3*exp(-lambda3*t);

% Construction de la TF séquentielle : H(s) = s * Y(s)
s = tf('s');
H_seq = yss_est + (c1*s)/(s+lambda1) + (c2*s)/(s+lambda2) + (c3*s)/(s+lambda3);

%% 3. Identification via System Identification Toolbox (tfest)
% On définit l'entrée comme un échelon unité (step)
u = ones(size(y));
data = iddata(y, u, Ts);

% Estimation d'une fonction de transfert (3 pôles, 3 zéros pour correspondre à la structure)
% Note: tfest estime par défaut en temps continu si les données sont iddata
sys_ident = tfest(data, 3, 3);
y_ident = step(sys_ident, t);

%% 4. Comparaison et Affichage
figure('Name', 'Comparaison des méthodes d''identification');
plot(t, y, 'k.', 'MarkerSize', 8, 'DisplayName', 'Données bruitées'); hold on;
plot(t, y_seq, 'r', 'LineWidth', 1.5, 'DisplayName', 'Méthode Séquentielle');
plot(t, y_ident, 'b--', 'LineWidth', 1.5, 'DisplayName', 'tfest (Toolbox)');
grid on;
xlabel('Temps (s)'); ylabel('Amplitude');
legend('Location', 'best');
title('Comparaison : Peeling Manuel vs tfest');

% Affichage des résultats dans la console
fprintf('--- Résultats Méthode Séquentielle ---\n');
fprintf('Pôles identifiés : [%.3f, %.3f, %.3f]\n', -lambda1, -lambda2, -lambda3);
fprintf('Condition initiale y(0) : %.3f (Cible: 0.10)\n', yss_est+c1+c2+c3);

fprintf('\n--- Résultats tfest ---\n');
disp(sys_ident);

%% 5. Export PDF
set(gcf,'Units','centimeters');
pos = get(gcf,'Position');
set(gcf, 'PaperPosition', [0 0 pos(3) pos(4)], 'PaperSize', [pos(3) pos(4)]);
print -dpdf -painters FigureIdentification