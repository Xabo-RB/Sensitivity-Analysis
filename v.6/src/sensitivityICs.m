function sensitivityICs(model, opts, ode_function)    

    % Parameter values
    p = model.param_values;
    % Initial condition values original
    Original_x0 = model.x0;
    pI = length(Original_x0);
    
    % nNumber of the state that is going to be analysed
    nIC = opts.nStaIC;    
    
    % Limit of the range for analysing the sensitivity
    rango_min= model.ICs_ranges(1);
    rango_max= model.ICs_ranges(2);
    
    h = waitbar(0, sprintf('Computing IC sensitivity for %s_0...', ...
                           model.state_names{nIC}));

    tic
    
    if model.range_typeICs == 1

        % Points within the range of sensitivity
        stateVect = logspace(rango_min, log10(rango_max), model.number_samplesICs);

    elseif model.range_typeICs == 2
    
        model.number_samplesICs = 1000;
        stateVect = model.param_rangesICs;

    elseif model.range_typeICs == 3

        stateVect = model.param_rangesICs;
    
    end   

    

    results_matrix = zeros(model.number_samplesICs, length(model.tspan));

    if opts.usar_paralelo
    
        % En cálculo paralelo crearía problemas de eficiencia pasar las
        % variables en forma de struct (sale un warning)
        d = opts.d;
        solver = opts.solver;
        rel_tol = opts.rel_tol;
        abs_tol = opts.abs_tol;

        parfor i = 1:model.number_samplesICs

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

        for i = 1:model.number_samplesICs
            
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
            
            % Poniendo el número en el que está del sample
            %waitbar(i / model.number_samplesICs, h, sprintf('Computing IC sample %d of %d...', i, model.number_samplesICs));
            % Sin él
            waitbar(i / model.number_samplesICs, h, sprintf('Computing...'));

        end

    end

    PlotResultsICs(results_matrix, ode_function, model.param_values, model.x0, model.tspan, stateVect, nIC, model.state_index, model.param_names, model.state_names, opts);
    toc

    close(h);

end