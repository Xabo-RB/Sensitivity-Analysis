%% === SENSITIVITY CODE ===
% This script evaluates the sensitivity of an ODE model with respect to an user-defined set of parameters.
% For each parameter, it generates a normalized sensitivity matrix and produces a results figure.

%%
function SensitivityOrganizer()
    opts = options();
    
    % Create the name of the function handle type variable that is going to analyse
    ode_function  = str2func(opts.modelname);
    
    % Run the corresponding options file
    options_script = [opts.modelname '_options'];
    if exist([options_script '.m'], 'file')
        eval(options_script);
    else
        error(['File ' options_script '.m not found']);
    end
    
    % Initialize the parallel processing pool if it is not active and if it is
    % required by the user
    if opts.usar_paralelo && isempty(gcp('nocreate'))
        parpool;
    end
    
    param_values_original = model.param_values;
    x0_real = real(model.x0);
    num_params = length(model.param_values);
    
    % === LOOP OF PARAMETERS TO ANALYZE ===
    % (Puede ser con cálculo paralelo o de manera normal)
    for pI = 1:num_params  
        tic

        % rango_max_param = 5 * param_values_original(pI);
        % ModelVect = linspace(0, rango_max_param, model.number_samples);
        
        % 3 magnitudes por encima y 3 por debajo
        p0 = param_values_original(pI);
        rango_min_param = p0 * 1e-3;
        rango_max_param = p0 * 1e3;
        ModelVect = logspace(log10(rango_min_param), log10(rango_max_param), model.number_samples);

        results_matrix = zeros(model.number_samples, length(model.tspan));
    
        if opts.usar_paralelo
        
            % En cálculo paralelo crearía problemas de eficiencia pasar las
            % variables en forma de struct (sale un warning)
            d = opts.d;
            solver = opts.solver;
            rel_tol = opts.rel_tol;
            abs_tol = opts.abs_tol;

            parfor i = 1:model.number_samples

                local_params = param_values_original;
                local_params(pI) = ModelVect(i);
                p = complex(local_params, 0);        
        
                % Run the ODE integration with the modified parameters
                sol = sensitivityMain(x0_real, p, d, model.tspan, ode_function, solver, rel_tol, abs_tol);
        
                % Extract the response corresponding to the status of interest
                response = sol{model.state_index}(:, pI + 1);
                normalized = (response .* ModelVect(i)) ./ sol{model.state_index}(:, 1);
                results_matrix(i, :) = normalized.';
            end
        else
    
            for i = 1:model.number_samples
                
                % No modifico el original, hago una copia cada vez
                local_params = param_values_original;
                % Equivalente a p = complex([5e-5, koffVect(i), 1, 0.09, 1000, 10000, 1000], 0);
                local_params(pI) = ModelVect(i);
                p = complex(local_params, 0);        
        
                % Run the ODE integration with the modified parameters
                sol = sensitivityMain(x0_real, p, opts.d, model.tspan, ode_function, opts.solver, opts.rel_tol, opts.abs_tol);
        
                % Extract the response corresponding to the status of interest
                response = sol{model.state_index}(:, pI + 1);
                % Evolución del estado sin sensibilizar al parámetro
                evoX = sol{model.state_index}(:, 1);
                normalized = (response .* ModelVect(i)) ./ evoX;
                %results_matrix(i, :) = normalized.';
                results_matrix(i, :) = normalized;
            end
    
        end
    
        PlotResults(results_matrix, ode_function, model.param_values, model.x0, model.tspan, ModelVect, pI, model.state_index, opts.modelname, model.param_names, model.state_names, opts.solver, opts.rel_tol, opts.abs_tol, opts.visualization_choice);
        disp(['Generated figures for parameter ' num2str(pI) ' of ' num2str(length(model.param_values))]);
        toc
    end
end



