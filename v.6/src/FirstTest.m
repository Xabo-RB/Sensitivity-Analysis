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

    p = model.param_values;
    x0 = model.x0;
    tspan = model.tspan;

    % Solución de referencia
    opts_ref = odeset('RelTol', 1e-12, 'AbsTol', 1e-12, 'Refine', 1);
    [t_ref, x_ref] = ode15s(@(t,y) ode_function(t,y,p), tspan, x0, opts_ref);

    options_ode  = odeset('RelTol', opts.rel_tol, 'AbsTol', opts.abs_tol, 'Refine', 1);
    results = struct();
    
    for i = 1:nSolvers
        solver_handle = solver_list{i};
        solver_name = func2str(solver_handle);

        try
            tic
            [t, x] = solver_handle(@(t,y) ode_function(t, y, p), tspan, x0, options_ode);
            elapsed_time = toc;

            % Interpolar referencia en la malla temporal del solver actual
            x_ref_interp = interp1(t_ref, x_ref, t, 'pchip');
            err = x - x_ref_interp;
            max_error = max(abs(err), [], 'all');
            rms_error = sqrt(mean(err(:).^2));

            results(i).solver = solver_name;
            results(i).t = t;
            results(i).x = x;
            results(i).time = elapsed_time;
            results(i).success = true;
            results(i).max_error = max_error;
            results(i).rms_error = rms_error;            
            results(i).message = '';

            fprintf('Solver %s completed in %.6f s | Max error = %.3e | RMS error = %.3e\n', ...
            solver_name, elapsed_time, max_error, rms_error);

        catch ME
            results(i).solver = solver_name;
            results(i).t = [];
            results(i).x = [];
            results(i).time = NaN;
            results(i).success = false;
            results(i).max_error = NaN;
            results(i).rms_error = NaN;
            results(i).message = ME.message;

            fprintf('Solver %s failed: %s\n', solver_name, ME.message);
        end
    end

    time_s = [results.time];
    max_err = [results.max_error];
    rms_err = [results.rms_error];
    solver_names = {results.solver};

    figure;
    
    % === Subplot 1: tiempo ===
    subplot(2,1,1);
    bar(time_s);
    set(gca, 'XTick', 1:nSolvers, 'XTickLabel', solver_names);
    xtickangle(45);
    ylabel('Execution time (s)');
    title('Solver comparison');
    grid on;
    
    % === Subplot 2: errores ===
    subplot(2,1,2);
    semilogy(1:nSolvers, max_err, '-o', 'LineWidth', 1.5, 'DisplayName', 'Max error');
    hold on;
    semilogy(1:nSolvers, rms_err, '-s', 'LineWidth', 1.5, 'DisplayName', 'RMS error');
    set(gca, 'XTick', 1:nSolvers, 'XTickLabel', solver_names);
    xtickangle(45);
    ylabel('Error (log scale)');
    xlabel('Solver');
    legend('Location','best');
    grid on;



end