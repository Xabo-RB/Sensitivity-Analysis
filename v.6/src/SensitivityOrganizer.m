%% === SENSITIVITY CODE ===
% This script evaluates the sensitivity of an ODE model with respect to an user-defined set of parameters.
% For each parameter, it generates a normalized sensitivity matrix and produces a results figure.

%%
function SensitivityOrganizer()
    opts = options();
        
    % Run the corresponding options file
    options_script = [opts.modelname '_options'];
    if exist([options_script '.m'], 'file')
        eval(options_script);
    else
        error(['File ' options_script '.m not found']);
    end
    
    if model.ifu1
        % Intento input
        ode_base  = str2func(opts.modelname);
        ode_function = @(t,x,p) ode_base(t, x, p, model.tspan, model.u1);
    else
        % Create the name of the function handle type variable that is going to analyse
        ode_function  = str2func(opts.modelname);
    end
    
    % Initialize the parallel processing pool if it is not active and if it is
    % required by the user
    if opts.usar_paralelo && isempty(gcp('nocreate'))
        parpool;
    end
    
    % For analysing the sensitivity to initial conditions we move to another script.
    if opts.ICsens 

        sensitivityICs(model, opts, ode_function);
        
    else

        sensitivityParams(model, opts, ode_function);

    end
end



