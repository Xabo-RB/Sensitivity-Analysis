function PlotResults(results_matrix, ode_function, param_values, x0, tspan, ModelVect, pI, state_index, modelname, param_names, state_names, solver, rel_tol, abs_tol, visualization_choice)

    switch visualization_choice
        case 1
            name_visual = 'gray';
        case 2
            name_visual = 'inferno';
        %case 3
            %name_visual = 'contour';
    end

    % % === OUTPUT FOLDER ===
    % solver_name = func2str(solver);
    % output_folder = fullfile(pwd, 'results', ...
    %     ['Sensitivity_Images_' modelname '_' solver_name '_' num2str(rel_tol) '_' num2str(abs_tol) '_' name_visual]);
    % if ~exist(output_folder, 'dir')
    %     mkdir(output_folder);
    % end

    % === OUTPUT FOLDER ===
    solver_name = func2str(solver);
    output_folder = fullfile(pwd, 'results', ...
        ['Sensitivity_Images_' modelname '_' name_visual]);
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end
    
    % === GENERATE INFO FILE TXT ===

    info_path = fullfile(output_folder, 'run_options.txt');
    fid = fopen(info_path, 'w');

    fprintf(fid, '=== RUN CONFIGURATION ===\n\n');

    fprintf(fid, 'Model: %s\n', modelname);
    fprintf(fid, 'ODE function: %s.m\n', func2str(ode_function));
    fprintf(fid, 'Solver: %s\n', func2str(solver));
    fprintf(fid, 'Relative Tolerance: %g\n', rel_tol);
    fprintf(fid, 'Absolute Tolerance: %g\n', abs_tol);
    fprintf(fid, 'Visualization: %s (option %d)\n', name_visual, visualization_choice);
    fprintf(fid, 'State analyzed: %s (index %d)\n', state_names{state_index}, state_index);
    fprintf(fid, 'Simulation step size: %g\n', tspan(2) - tspan(1));
    fprintf(fid, 'Simulation end time: %g\n', tspan(end));
    fprintf(fid, 'Sensitivity iterations: %d\n\n', size(results_matrix, 1));
    fprintf(fid, '=== MODEL PARAMETERS ===\n');
    for k = 1:length(param_names)
        fprintf(fid, '%s = %.5g\n', param_names{k}, param_values(k));
    end
    fprintf(fid, '\n');
    fprintf(fid, '=== MODEL STATES ===\n');
    for k = 1:length(state_names)
        fprintf(fid, '%s = %.5g\n', state_names{k}, real(x0(k)));
    end
    
    fclose(fid);
    
    % === PLOT FIGURES (NORMAL AND LOG SCALE) ===
    matrix_to_plot = abs(results_matrix);

    % === NORMAL SCALE FIGURE ===
    figura_normal = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    switch visualization_choice
        case 1
            contourf(tspan, ModelVect, matrix_to_plot, 10, 'LineColor', 'k');
            colormap(gray);
            cb = colorbar;
            cb.Label.String = 'Sensitivity';
        case 2
            inferno = csvread('inferno_colormap.csv');
            contourf(tspan, ModelVect, matrix_to_plot, 10, 'LineColor', 'k');
            colormap(inferno);
            cb = colorbar;
            cb.Label.String = 'Sensitivity';
        %case 3
            %contour(tspan, CARTVect, matrix_to_plot, 10, 'LineColor', 'k');
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
    results_matrix_log = log10(results_matrix);
    figura_log = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    switch visualization_choice
        case 1
            contourf(tspan, ModelVect, real(results_matrix_log), 10, 'LineColor', 'k');
            colormap(gray);
            cb = colorbar;
            cb.Label.String = 'Sensitivity';
        case 2
            inferno = csvread('inferno_colormap.csv');
            contourf(tspan, ModelVect, real(results_matrix_log), 10, 'LineColor', 'k');
            colormap(inferno);
            cb = colorbar;
            cb.Label.String = 'Sensitivity';
        %case 3
            %contour(tspan, CARTVect, real(results_matrix_log), 10, 'LineColor', 'k');
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
