% (Mêmes paramètres et calculs que votre script précédent)
% ... [Sections 1 à 4 identiques] ...

for scenario = 1:2
    % ... [Initialisation et Boucle de calcul identiques] ...
    
    % --- Plotting ---
    fig = figure('Name', title_str, 'Color', 'w', 'Position', [100, 100, 900, 700]);
    names = {'Position $r$ (m)', 'Velocity $\dot{r}$ (m/s)', ...
             'Angle $\theta$ (rad)', 'Ang. Velocity $\dot{\theta}$ (rad/s)'};
             
    for i = 1:4
        subplot(2,2,i);
        plot(t, X_hist(i,:), 'k', 'LineWidth', 1.5, 'DisplayName', 'True state'); hold on;
        plot(t, XS_hist(i,:), '--', 'DisplayName', 'L Slow');
        plot(t, XM_hist(i,:), '-.', 'DisplayName', 'L Med');
        plot(t, XF_hist(i,:), ':', 'DisplayName', 'L Fast');
        plot(t, XK_hist(i,:), 'Color', [0 0.5 0], 'LineWidth', 1.2, 'DisplayName', 'Kalman'); % Vert pour distinguer
        grid on; ylabel(names{i}); xlabel('Time (s)');
        if i == 1, legend('Location', 'best', 'FontSize', 8); title(title_str); end
    end

    % --- Exportation dynamique ---
    if scenario == 1
        exportgraphics(fig, 'FigureBallBeam_OpenLoop.pdf', 'ContentType', 'vector');
    else
        exportgraphics(fig, 'FigureBallBeam_ClosedLoop.pdf', 'ContentType', 'vector');
    end
end