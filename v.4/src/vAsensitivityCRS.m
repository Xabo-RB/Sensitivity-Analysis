% === SENSITIVITY CODE ===

if isempty(gcp('nocreate'))
    parpool;
end

param_values_original = param_values;
x0_real = real(x0);

% === LOOP OF PARAMETERS TO ANALYZE ===
for pI = 1:3
    tic
    rango_max_param = 5 * param_values_original(pI);
    CARTVect = linspace(0, rango_max_param, t_end);
    results_matrix = zeros(t_end, length(tspan));

    parfor i = 1:t_end
        local_params = param_values_original;
        local_params(pI) = CARTVect(i);
        p = complex(local_params, 0);
        sol = sensitivityMain(x0_real, p, 1e-16, tspan, ode_function, solver, rel_tol, abs_tol);
        response = sol{state_index}(:, pI + 1);
        normalized = (response .* CARTVect(i)) ./ sol{state_index}(:, 1);
        results_matrix(i, :) = normalized.';
    end

    % % === NORMAL SCALE FIGURE ===
    % figura_normal = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    % contourf(tspan, CARTVect, results_matrix, 10, 'LineColor', 'k');
    % colormap(gray);
    % cb = colorbar;
    % cb.Label.String = 'Sensitivity';
    % xlabel('Time (s)', 'FontSize', 18);
    % ylabel(param_names{pI}, 'FontSize', 18, 'Rotation', 0);
    % title([modelname ': Sensitivity of ' state_names{state_index} ' to ' param_names{pI}], ...
    %     'FontSize', 18, 'FontWeight', 'bold');
    % set(gca, 'YDir', 'normal');
    % exportgraphics(figura_normal, fullfile(output_folder, ...
    %     [modelname '_Parameter_' num2str(pI) '_State_' num2str(state_index) '.png']), ...
    %     'BackgroundColor','white','ContentType','image');
    % close(figura_normal);
    % 
    % % === LOG SCALE FIGURE ===
    % results_matrix_log = log10(abs(results_matrix));
    % figura_log = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    % contourf(tspan, CARTVect, results_matrix_log, 10, 'LineColor', 'k');
    % colormap(gray);
    % cb = colorbar;
    % cb.Label.String = 'Sensitivity';
    % xlabel('Time (s)', 'FontSize', 18);
    % ylabel(param_names{pI}, 'FontSize', 18, 'Rotation', 0);
    % title([modelname ': Sensitivity of ' state_names{state_index} ' (log) to ' param_names{pI}], ...
    %     'FontSize', 18, 'FontWeight', 'bold');
    % set(gca, 'YDir', 'normal');
    % exportgraphics(figura_log, fullfile(output_folder, ...
    %     [modelname '_Parameter_' num2str(pI) '_State_' num2str(state_index) '_log.png']), ...
    %     'BackgroundColor','white','ContentType','image');
    % close(figura_log);
    % 
    % disp(['Generated figures for parameter ' num2str(pI) ' of ' num2str(length(param_values))]);
    PlotResults(results_matrix, ode_function, param_values, x0, tspan, CARTVect, pI, state_index, modelname, param_names, state_names, solver, rel_tol, abs_tol, visualization_choice);
    disp(['Generated figures for parameter ' num2str(pI) ' of ' num2str(length(param_values))]);
    toc
end



