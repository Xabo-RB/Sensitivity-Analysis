% =========================================================================
% USER OPTIONS FOR SENSITIVITY ANALYSIS
% =========================================================================

% === MODEL SELECTION ===
%   Acronym given to the model in the file in models folder
modelname     = 'OccupancyTCR';          

% === TOLERANCES ===
rel_tol = 1e-9;                 %   Relative Tolerance.   
abs_tol = 1e-12;                %   Absolute Tolerance.

% === SOLVER AND STEP ===
solver = @ode45;                %   Some examples: @ode15, @ode23s, @ode45...
d = 1.0e-16;

% === PARALLEL COMPUTING ===
usar_paralelo = false; % 'true' or 'false'

% === VISUALIZATION OPTIONS ===
visualization_choice = 2;       %   1 - Results are shown in Heatmap form, GRAY scale.
                                %   2 - Results are shown in Heatmap form, INFERNO scale.