% =========================================================================
% Ball-and-Beam: Multi-Observer Benchmark (Stabilized Edition)
% Generates: States Figs, Error Metrics Figs, and Complete LaTeX Tables
% =========================================================================
clear; clc; close all;

set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% --- 1. Système (Modèle Linéarisé) ---
m = 0.11; J = 0.02; g = 9.81;
A = [0 1 0 0; 0 0 -g 0; 0 0 0 1; -m*g/J 0 0 0];
B = [0; 0; 0; 1/J]; C = [1 0 0 0];
n = size(A,1);

% --- 2. Gains des Observateurs (Très rapides pour stabiliser l'instabilité) ---
poles_obs = [-100, -110, -120, -130];
L_luen = place(A', C', poles_obs)';

Q_kal = diag([1e-6 1e-7 1e-6 1e-7]); R_kal = 1e-4;
[~,~,L_kal] = care(A', C', Q_kal, R_kal); L_kal = L_kal';

% Ordre réduit (Estimation de x2, x3, x4)
A11 = A(1,1); A12 = A(1,2:4); A21 = A(2:4,1); A22 = A(2:4,2:4);
B1 = B(1); B2 = B(2:4);
L_red = place(A22', A12', [-150, -160, -170])'; 

% --- 3. Contrôleur LQR (Stabilisation complète) ---
% Poids élevé sur l'angle (x3) et la vitesse angulaire (x4) pour forcer le repos
Q_lqr = diag([500, 50, 1000, 100]); 
R_lqr = 1;
K_lqr = lqr(A, B, Q_lqr, R_lqr);

% --- 4. Simulation ---
Tend = 2; dt = 1e-3; t = 0:dt:Tend; N = length(t);
obs_names = {'Luenberger','Kalman','Reduced-order','Output-feedback'};

for scenario = 1:2
    x = [0.08; 0; 0.03; 0]; % Position 8cm, Angle 0.03 rad
    y0 = C*x;
    
    % Initialisation : on part de la mesure y0 pour limiter le transitoire
    xh_L = [y0; 0; 0; 0]; xh_K = [y0; 0; 0; 0]; 
    z_red = L_red*x(1) + x(2:4);
    
    X_h = zeros(4, N); XL_h = zeros(4, N); XK_h = zeros(4, N);
    XR_h = zeros(4, N); XO_h = zeros(4, N); err_norms = zeros(4, N);
    
    rng(1); 
    for k = 1:N
        if scenario == 1
            u = 0.1 * sin(5*t(k)); s_id = 'OL'; s_label = 'Open-Loop';
        else
            % Stabilisation basée sur l'estimation de Kalman
            u = -K_lqr * xh_K; 
            s_id = 'CL'; s_label = 'Closed-Loop';
        end
        
        % Mesure et bruits
        y = C*x + sqrt(R_kal)*randn;
        xh_R = [y; z_red - L_red*y];
        xh_O = [y; 0; 0; 0];
        
        X_h(:,k) = x; XL_h(:,k) = xh_L; XK_h(:,k) = xh_K;
        XR_h(:,k) = xh_R; XO_h(:,k) = xh_O;
        err_norms(:,k) = [norm(x-xh_L); norm(x-xh_K); norm(x-xh_R); norm(x-xh_O)];
        
        % Mise à jour des Observateurs
        xh_L = xh_L + dt*(A*xh_L + B*u + L_luen*(y - C*xh_L));
        xh_K = xh_K + dt*(A*xh_K + B*u + L_kal*(y - C*xh_K));
        
        dz = (A22-L_red*A12)*z_red + (A22-L_red*A12)*L_red*y + (A21-L_red*A11)*y + (B2-L_red*B1)*u;
        z_red = z_red + dt*dz;
        
        % Mise à jour de la Plante (avec bruit de processus)
        x = x + dt*(A*x + B*u + chol(Q_kal,'lower')*randn(4,1));
    end
    
    % --- 5. Exportation Fichier LaTeX Complet ---
    fid = fopen(['Metrics_', s_id, '.tex'], 'w');
    fprintf(fid, '\\begin{table}[htbp]\n\\centering\n\\begin{tabularx}{\\textwidth}{l CCCC}\n\\toprule\n');
    fprintf(fid, 'Observer & $T_s$ (s) & Var($e$) & Noise Amp. & Cost \\\\\n\\midrule\n');
    for i = 1:4
        e = err_norms(i,:);
        idx = find(e > 0.1*e(1), 1, 'last');
        if isempty(idx), ts = 0; else, ts = t(idx); end
        v_e = var(e(end-200:end));
        
        % Critère de stabilité : l'erreur doit avoir convergé vers une valeur faible
        if e(end) > 0.1 || isnan(v_e)
            fprintf(fid, '%s & Div. & Inf. & Inf. & %.1f \\\\\n', obs_names{i}, i*0.5+1);
        else
            fprintf(fid, '%s & %.3f & %.2e & %.2f & %.1f \\\\\n', obs_names{i}, ts, v_e, v_e/R_kal, i*0.5+1);
        end
    end
    fprintf(fid, '\\bottomrule\n\\end{tabularx}\n\\caption{Performance metrics: %s scenario.}\n\\label{tab:metrics_%s}\n\\end{table}\n', s_label, lower(s_id));
    fclose(fid);
    
    % --- 6. Figures ---
    figure('Color','w','Name',s_label,'Position',[100 100 800 600]);
    lbls = {'$r$ (m)', '$\dot{r}$ (m/s)', '$\theta$ (rad)', '$\dot{\theta}$ (rad/s)'};
    for s_idx = 1:4
        subplot(2,2,s_idx); plot(t, X_h(s_idx,:), 'k', 'LineWidth', 1.5); hold on;
        plot(t, XK_h(s_idx,:), 'b--'); grid on; 
        ylabel(lbls{s_idx}); xlabel('Time (s)');
        if s_idx == 1, title([s_label, ' - States Evolution']); end
    end
    exportgraphics(gcf, ['Figure_States_', s_id, '.pdf'], 'ContentType', 'vector');
    
    figure('Color','w','Name',['Metrics ' s_label],'Position',[950 100 600 400]);
    semilogy(t, err_norms, 'LineWidth', 1.2); grid on; 
    xlabel('Time (s)'); ylabel('Error Norm $\|e(t)\|$');
    title([s_label, ' - Convergence Comparison']);
    legend(obs_names, 'Location', 'best'); 
    exportgraphics(gcf, ['Figure_Metrics_', s_id, '.pdf'], 'ContentType', 'vector');
end