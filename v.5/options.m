% =========================================================================
% USER OPTIONS FOR SENSITIVITY ANALYSIS
% =========================================================================
function opts = options()

    % === MODEL SELECTION ===
    %   Acronym given to the model in the file in models folder
    opts.modelname     = 'OccupancyTCR';          
    
    % === TOLERANCES ===
    opts.rel_tol = 1e-9;                 %   Relative Tolerance.   
    opts.abs_tol = 1e-12;                %   Absolute Tolerance.
    
    % === SOLVER AND STEP ===
    opts.solver = @ode45;                %   Some examples: @ode15, @ode23s, @ode45...
    opts.d = 1.0e-16;
    
    % === PARALLEL COMPUTING ===
    opts.usar_paralelo = false; % 'true' or 'false'
    
    % === VISUALIZATION OPTIONS ===
    opts.visualization_choice = 1;       %   1 - Results are shown in Heatmap form, GRAY scale.
                                    %   2 - Results are shown in Heatmap form, INFERNO scale.

end