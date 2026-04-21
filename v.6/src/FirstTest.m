function results = FirstTest()

    opts = options();

    options_script = [opts.modelname '_options'];
    if exist([options_script '.m'], 'file')
        eval(options_script);
    else
        error(['File ' options_script '.m not found']);
    end
    if model.ifU1
        ode_base  = str2func(opts.modelname);
        ode_function = @(t,x,p) ode_base(t, x, p, model.tspan, model.u1);
    else
        % Create the name of the function handle type variable that is going to analyse
        ode_function  = str2func(opts.modelname);
    end
    
    % For analysing the sensitivity to initial conditions we move to another script.
    if opts.ICsens 

        sensitivityICs(model, opts, ode_function);
        return
    end

    % Solvers de MATLAB para ODEs
    solver_list = {@ode45, @ode23, @ode113, @ode78, @ode89, @ode15s, @ode23s, @ode23t, @ode23tb};
    nSolvers = numel(solver_list);

    x0 = model.x0;
    tspan = model.tspan;

    % Construcción de todos los vetores de combinaciones de parámetros a integrar
    p = model.param_values.';
    pmin = model.param_range_min.';
    pmax = model.param_range_max.';

    nParams = numel(p);
    nCombs = 1 + 2*nParams;

    totalCombs = zeros(nCombs, nParams);

    totalCombs(1,:) = p;
    idx = 2;
    for j = 1:nParams
        aux = p;
        aux(j) = pmin(j);
        totalCombs(idx,:) = aux;
        idx = idx + 1;
    
        aux = p;
        aux(j) = pmax(j);
        totalCombs(idx,:) = aux;
        idx = idx + 1;
    end

    % Opciones de referencia
    opts_ref = odeset('RelTol', 1e-12, 'AbsTol', 1e-12, 'Refine', 1);

    options_ode  = odeset('RelTol', opts.rel_tol, 'AbsTol', opts.abs_tol, 'Refine', 1);
    results = struct();

    for i = 1:nSolvers
        results(i).solver = func2str(solver_list{i});
        results(i).times = NaN(1,nCombs);
        results(i).max_errors = NaN(1,nCombs);
        results(i).rms_errors = NaN(1,nCombs);
        results(i).success = false(1,nCombs);
        results(i).messages = cell(1,nCombs);
        results(i).t = cell(1,nCombs);
        results(i).x = cell(1,nCombs);
    end
    
    for k = 1:nCombs

        pReferencia = totalCombs(k,:);
        % Solución de referencia para esta combinación
        [t_ref, x_ref] = ode15s(@(t,y) ode_function(t,y,pReferencia), tspan, x0, opts_ref);

        for i = 1:nSolvers
            solver_handle = solver_list{i};
            solver_name = func2str(solver_handle);
    
            try
                tic
                [t, x] = solver_handle(@(t,y) ode_function(t, y, pReferencia), tspan, x0, options_ode);
                elapsed_time = toc;
    
                % Interpolar referencia en la malla temporal del solver actual
                x_ref_interp = interp1(t_ref, x_ref, t, 'linear');
                err = x - x_ref_interp;
                max_error = max(abs(err), [], 'all');
                rms_error = sqrt(mean(err(:).^2));
    
                results(i).solver = solver_name;
                results(i).times(k) = elapsed_time;
                results(i).max_errors(k) = max_error;
                results(i).rms_errors(k) = rms_error;
                results(i).success(k) = true;
                results(i).messages{k} = '';
                results(i).t{k} = t;
                results(i).x{k} = x;
    
                % fprintf('Comb %d | Solver %s completed in %.6f s | Max error = %.3e | RMS error = %.3e\n', ...
                % k, solver_name, elapsed_time, max_error, rms_error);
    
            catch ME

                results(i).solver = solver_name;
                results(i).times(k) = NaN;
                results(i).max_errors(k) = NaN;
                results(i).rms_errors(k) = NaN;
                results(i).success(k) = false;
                results(i).messages{k} = ME.message;
                results(i).t{k} = [];
                results(i).x{k} = [];
    
                % fprintf('Comb %d | Solver %s failed: %s\n', k, solver_name, ME.message);
            end
        end
    end

    for i = 1:nSolvers
        results(i).time = mean(results(i).times, 'omitnan');
        results(i).max_error = mean(results(i).max_errors, 'omitnan');
        results(i).rms_error = mean(results(i).rms_errors, 'omitnan');
    end

    time_s = [results.time];
    max_err = [results.max_error];
    rms_err = [results.rms_error];
    solver_names = {results.solver};

    % figure;
    % 
    % % === Subplot 1: tiempo ===
    % subplot(2,1,1);
    % bar(time_s);
    % set(gca, 'XTick', 1:nSolvers, 'XTickLabel', solver_names);
    % xtickangle(45);
    % ylabel('Execution time (s)');
    % title('Solver comparison');
    % grid on;
    % 
    % % === Subplot 2: errores ===
    % subplot(2,1,2);
    % semilogy(1:nSolvers, max_err, '-o', 'LineWidth', 1.5, 'DisplayName', 'Max error');
    % hold on;
    % semilogy(1:nSolvers, rms_err, '-s', 'LineWidth', 1.5, 'DisplayName', 'RMS error');
    % set(gca, 'XTick', 1:nSolvers, 'XTickLabel', solver_names);
    % xtickangle(45);
    % ylabel('Error (log scale)');
    % xlabel('Solver');
    % legend('Location','best');
    % grid on;
    % 
    % figure('Color','w','Position',[100 100 900 650]);

    figure('Color','w','Position',[100 100 900 650]);
    
    tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
    
    % ==============================
    % Preparación: ordenar por tiempo
    % ==============================
    [time_sorted, idx] = sort(time_s, 'ascend');
    solver_names_sorted = solver_names(idx);
    max_err_sorted = max_err(idx);
    rms_err_sorted = rms_err(idx);
    
    % === Gráfico 1: tiempo de ejecución ===
    nexttile;
    bar(1:nSolvers, time_sorted, ...
        'FaceColor',[0.2 0.5 0.8], ...
        'EdgeColor','none', ...
        'BarWidth',0.7);
    
    set(gca, 'XTick', 1:nSolvers, 'XTickLabel', solver_names_sorted, ...
        'FontSize',11, 'Box','off', 'TickDir','out');
    xtickangle(35);
    ylabel('Execution time (s)', 'FontSize',12);
    title('Solver comparison by execution time', 'FontSize',14, 'FontWeight','bold');
    grid on;
    ax = gca;
    ax.GridAlpha = 0.15;
    ax.MinorGridAlpha = 0.08;
    ax.YMinorGrid = 'on';
    
    % Etiquetas con valor encima de cada barra
    ylim_curr = ylim;
    offset = 0.015 * (ylim_curr(2)-ylim_curr(1));
    for i = 1:nSolvers
        text(i, time_sorted(i) + offset, sprintf('%.3g s', time_sorted(i)), ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','bottom', ...
            'FontSize',10, ...
            'Color',[0.2 0.2 0.2]);
    end
    
    % === Gráfico 2: errores ===
    nexttile;
    semilogy(1:nSolvers, max_err_sorted, '-o', ...
        'LineWidth',1.8, 'MarkerSize',7, ...
        'MarkerFaceColor',[0.85 0.33 0.10], ...
        'Color',[0.85 0.33 0.10], ...
        'DisplayName','Max error');
    hold on;
    
    semilogy(1:nSolvers, rms_err_sorted, '-s', ...
        'LineWidth',1.8, 'MarkerSize',7, ...
        'MarkerFaceColor',[0.00 0.45 0.74], ...
        'Color',[0.00 0.45 0.74], ...
        'DisplayName','RMS error');
    
    set(gca, 'XTick', 1:nSolvers, 'XTickLabel', solver_names_sorted, ...
        'FontSize',11, 'Box','off', 'TickDir','out');
    xtickangle(35);
    ylabel('Error (log scale)', 'FontSize',12);
    xlabel('Solver', 'FontSize',12);
    title('Accuracy comparison', 'FontSize',14, 'FontWeight','bold');
    legend('Location','best','Box','off');
    grid on;
    ax = gca;
    ax.GridAlpha = 0.15;
    ax.YMinorGrid = 'on';


end