function sensitivityICs(model, opts)    

    % Parameter values
    p = model.param_values;
    % Initial condition values original
    Original_x0 = real(model.x0);
    pI = length(Original_x0);
    
    % nNumber of the state that is going to be analysed
    nIC = opts.nStaIC;    
    
    % Limit of the range for analysing the sensitivity
    rango_min= opts.rango(1);
    rango_max= opts.rango(2);
    
    h = waitbar(0, 'Computing sensitivity...');
    tic
    
    % Points within the range of sensitivity
    stateVect = logspace(log10(rango_min), log10(rango_max), model.number_samples);

    results_matrix = zeros(model.number_samples, length(model.tspan));

    if opts.usar_paralelo
    
        % En cálculo paralelo crearía problemas de eficiencia pasar las
        % variables en forma de struct (sale un warning)
        d = opts.d;
        solver = opts.solver;
        rel_tol = opts.rel_tol;
        abs_tol = opts.abs_tol;

        parfor i = 1:model.number_samples

            local_states = Original_x0;
            local_states(nIC) = stateVect(i);
            x0_real = complex(local_states, 0);
        
            sol = sensitivityMainICs(x0_real, p, d, model.tspan, ode_function, solver, rel_tol, abs_tol);
        
            response = sol{model.state_index}(:, nIC + 1);
            evoX     = sol{model.state_index}(:, 1);
            normalized = (response .* stateVect(i)) ./ evoX;
            results_matrix(i, :) = normalized;

        end
    else

        for i = 1:model.number_samples
            
            % No modifico el original, hago una copia cada vez
            local_states = Original_x0;

            % Equivalente a p = complex([5e-5, koffVect(i), 1, 0.09, 1000, 10000, 1000], 0);
            % Modifico el estado nIC con un valor nuevo del vector de puntos a analizar
            local_states(nIC) = stateVect(i);
            x0_real = complex(local_states, 0);        
    
            % Run the ODE integration with the modified parameters
            sol = sensitivityMainICs(x0_real, p, opts.d, model.tspan, ode_function, opts.solver, opts.rel_tol, opts.abs_tol);
    
            % Extract the response corresponding to the status of interest
            response = sol{model.state_index}(:, nIC + 1);
            % Evolución del estado sin sensibilizar al parámetro
            evoX = sol{model.state_index}(:, 1);
            normalized = (response .* stateVect(i)) ./ evoX;
            results_matrix(i, :) = normalized;
        end

    end

    PlotResults(results_matrix, ode_function, model.param_values, model.x0, model.tspan, stateVect, nIC, model.state_index, opts.modelname, model.param_names, model.state_names, opts.solver, opts.rel_tol, opts.abs_tol, opts.visualization_choice);
    toc
    close(h);

end