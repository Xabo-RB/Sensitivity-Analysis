function plotResults(results_matrix, tspan, CARTVect, pI, state_index, modelname, param_names, state_names, solver, rel_tol, abs_tol, visualization_choice)

    % === OUTPUT FOLDER ===
    solver_name = func2str(solver);
    output_folder = fullfile(pwd, ...
        ['Sensitivity_Images_' modelname '_' solver_name '_' num2str(rel_tol) '_' num2str(abs_tol)]);
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end
    
    % === PLOT FIGURES (NORMAL AND LOG SCALE) ===
    matrix_to_plot = abs(results_matrix);

    % === NORMAL SCALE FIGURE ===
    figura_normal = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    switch visualization_choice
        case 1
            contourf(tspan, CARTVect, matrix_to_plot, 10, 'LineColor', 'k');
            colormap(flipud(gray));
            cb = colorbar;
            cb.Label.String = 'Sensitivity';
        case 2
            inferno = csvread('inferno_colormap.csv');
            contourf(tspan, CARTVect, matrix_to_plot, 10, 'LineColor', 'k');
            colormap(inferno);
            cb = colorbar;
            cb.Label.String = 'Sensitivity';
        case 3
            contour(tspan, CARTVect, matrix_to_plot, 10, 'LineColor', 'k');
    end
    xlabel('Time (s)', 'FontSize', 18);
    ylabel(param_names{pI}, 'FontSize', 18, 'Rotation', 0);
    title([modelname ': Sensitivity of ' state_names{state_index} ' to ' param_names{pI}], ...
        'FontSize', 18, 'FontWeight', 'bold');
    set(gca, 'YDir', 'normal');
    
    nombre_normal = fullfile(output_folder, ...
        [modelname '_Parameter_' num2str(pI) '_State_' num2str(state_index)]);
    exportgraphics(figura_normal, [nombre_normal '.png'], 'BackgroundColor','white','ContentType','image');
    close(figura_normal);
    
    % === LOG SCALE FIGURE ===
    results_matrix_log = abs(log10(results_matrix));
    figura_log = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    switch visualization_choice
        case 1
            contourf(tspan, CARTVect, results_matrix_log, 10, 'LineColor', 'k');
            colormap(gray);
            cb = colorbar;
            cb.Label.String = 'Sensitivity';
        case 2
            inferno = csvread('inferno_colormap.csv');
            contourf(tspan, CARTVect, results_matrix_log, 10, 'LineColor', 'k');
            colormap(inferno);
            cb = colorbar;
            cb.Label.String = 'Sensitivity';
        case 3
            contour(tspan, CARTVect, results_matrix_log, 10, 'LineColor', 'k');
    end
    xlabel('Time (s)', 'FontSize', 18);
    ylabel(param_names{pI}, 'FontSize', 18, 'Rotation', 0);
    title([modelname ': Sensitivity of ' state_names{state_index} ' (log) to ' param_names{pI}], ...
        'FontSize', 18, 'FontWeight', 'bold');
    set(gca, 'YDir', 'normal');
    
    nombre_log = fullfile(output_folder, ...
        [modelname '_Parameter_' num2str(pI) '_State_' num2str(state_index) '_log']);
    exportgraphics(figura_log, [nombre_log '.png'], 'BackgroundColor','white','ContentType','image');
    close(figura_log);
end