% =========================================================================
% Comparison: Discrete Design (Ld) vs. Continuous Emulation (Lc)
% =========================================================================
clear; clc; close all;

% Configuration du rendu LaTeX
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% --- 1. Système Continu (Modèle Physique) ---
A = [0 1; -1 -0.5]; 
B = [0; 1]; 
C = [1 0];
pc = [-2 -2.5]; % Pôles continus ciblés
Ts = 0.4;       % Période d'échantillonnage élevée pour accentuer l'effet

% --- 2. Conception des Observateurs ---

% A. Design Continu pur (pour calcul du gain Lc)
Lc = place(A', C', pc)';

% B. Design Discret Direct (Ld) - La bonne méthode
sysd = c2d(ss(A, B, C, 0), Ts, 'zoh');
Ad = sysd.A; Bd = sysd.B; Cd = sysd.C;
pd = exp(pc * Ts); 
Ld = place(Ad', Cd', pd)';

% --- 3. Simulation ---
Tend = 12;
t_cont = 0:0.001:Tend; % Temps continu "réel"
t_disc = 0:Ts:Tend;    % Temps microcontrôleur

% Initialisation
x = [0.5; 0];          % État initial réel
xhat_direct = [0; 0];  % Observateur conçu en discret (Ld)
xhat_emul   = [0; 0];  % Observateur continu émulé (Lc utilisé en discret)

% Stockage
X_real = zeros(2, length(t_cont));
Xhat_direct_hist = zeros(2, length(t_disc));
Xhat_emul_hist   = zeros(2, length(t_disc));

% Simulation du système réel (Continu)
u_func = @(t) square(0.5*t); % Entrée en créneaux
sys_real = ss(A, B, C, 0);
[y_real, ~, x_real_out] = lsim(sys_real, u_func(t_cont), t_cont, x);
X_real = x_real_out';

% Simulation sur "Microcontrôleur" (Boucle récursive)
for k = 1:length(t_disc)
    tk = t_disc(k);
    uk = u_func(tk);
    yk = interp1(t_cont, y_real, tk); % Mesure échantillonnée par l'ADC
    
    % Sauvegarde
    Xhat_direct_hist(:,k) = xhat_direct;
    Xhat_emul_hist(:,k)   = xhat_emul;
    
    % 1. MÉTHODE DIRECTE (Ld) : Utilise le modèle Ad et le gain Ld
    xhat_direct = Ad*xhat_direct + Bd*uk + Ld*(yk - Cd*xhat_direct);
    
    % 2. MÉTHODE ÉMULÉE (Lc) : L'erreur classique. 
    % On utilise le gain continu Lc dans une structure de mise à jour discrète.
    % Pour être équitable, on utilise la discrétisation d'Euler du modèle :
    xhat_emul = xhat_emul + Ts*(A*xhat_emul + B*uk + Lc*(yk - C*xhat_emul));
end

% --- 4. Plotting ---
figure('Color', 'w', 'Units', 'centimeters', 'Position', [2, 2, 18, 12]);

subplot(2,1,1);
plot(t_cont, X_real(1,:), 'k', 'LineWidth', 1.5, 'DisplayName', 'True State $x_1$'); hold on;
stairs(t_disc, Xhat_direct_hist(1,:), 'b', 'LineWidth', 1.2, 'DisplayName', 'Discrete Design ($L_d$)');
stairs(t_disc, Xhat_emul_hist(1,:), 'r--', 'LineWidth', 1.2, 'DisplayName', 'Emulated Cont. ($L_c$)');
grid on; ylabel('$x_1$ (pos)');
title(['Stability Risk: Discrete vs. Emulated Observer ($T_s = ' num2str(Ts) '$s)']);
legend('Location', 'best');

subplot(2,1,2);
plot(t_cont, X_real(2,:), 'k', 'LineWidth', 1.5, 'DisplayName', 'True State $x_2$'); hold on;
stairs(t_disc, Xhat_direct_hist(2,:), 'b', 'LineWidth', 1.2, 'DisplayName', 'Discrete Design ($L_d$)');
stairs(t_disc, Xhat_emul_hist(2,:), 'r--', 'LineWidth', 1.2, 'DisplayName', 'Emulated Cont. ($L_c$)');
grid on; ylabel('$x_2$ (vel)'); xlabel('Time $t$ (s)');

% --- 5. Exportation ---
exportgraphics(gcf, 'FigureDiscreteVsEmulated.pdf', 'ContentType', 'vector');

% Diagnostic de stabilité
fprintf('Pôles Discrets (Ld) : [%.3f, %.3f] -> Toujours à l''intérieur du cercle unité.\n', eig(Ad-Ld*Cd));
fprintf('Pôles Emulés (Lc)   : [%.3f, %.3f] -> Risque de sortie du cercle unité.\n', eig(eye(2) + Ts*(A-Lc*C)));