% === SENSITIVITY CODE ===
% This script evaluates the sensitivity of an ODE model with respect to an user-defined set of parameters.
% For each parameter, it generates a normalized sensitivity matrix and produces a results figure.

% Create the name of the function handle type variable that is going to analyse
ode_function  = str2func(modelname);

% Run the corresponding options file
options_script = [modelname '_options'];
if exist([options_script '.m'], 'file')
    eval(options_script);
else
    error(['File ' options_script '.m not found']);
end

% Initialize the parallel processing pool if it is not active and if it is
% required by the user
if usar_paralelo && isempty(gcp('nocreate'))
    parpool;
end

param_values_original = param_values;
x0_real = real(x0);
num_params = length(param_values);

% === LOOP OF PARAMETERS TO ANALYZE ===
% (Puede ser con cálculo paralelo o de manera normal)
for pI = 1:num_params  
    tic
    rango_max_param = 5 * param_values_original(pI);
    ModelVect = linspace(0, rango_max_param, t_end);
    results_matrix = zeros(t_end, length(tspan));

    if usar_paralelo

        parfor i = 1:t_end
    
            local_params = param_values_original;
            local_params(pI) = ModelVect(i);
            p = complex(local_params, 0);        
    
            % Run the ODE integration with the modified parameters
            sol = sensitivityMain(x0_real, p, 1e-16, tspan, ode_function, solver, rel_tol, abs_tol);
    
            % Extract the response corresponding to the status of interest
            response = sol{state_index}(:, pI + 1);
            normalized = (response .* ModelVect(i)) ./ sol{state_index}(:, 1);
            results_matrix(i, :) = normalized.';
        end
    else

        for i = 1:t_end
    
            local_params = param_values_original;
            local_params(pI) = ModelVect(i);
            p = complex(local_params, 0);        
    
            % Run the ODE integration with the modified parameters
            sol = sensitivityMain(x0_real, p, 1e-16, tspan, ode_function, solver, rel_tol, abs_tol);
    
            % Extract the response corresponding to the status of interest
            response = sol{state_index}(:, pI + 1);
            normalized = (response .* ModelVect(i)) ./ sol{state_index}(:, 1);
            results_matrix(i, :) = normalized.';
        end

    end

    PlotResults(results_matrix, ode_function, param_values, x0, tspan, ModelVect, pI, state_index, modelname, param_names, state_names, solver, rel_tol, abs_tol, visualization_choice);
    disp(['Generated figures for parameter ' num2str(pI) ' of ' num2str(length(param_values))]);
    toc
end



