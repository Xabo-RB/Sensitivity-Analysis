% =========================================================================
% USER OPTIONS FOR SENSITIVITY ANALYSIS
% =========================================================================

% === MODEL SELECTION ===
%   Acronym given to the model in the file in models folder
modelname     = 'OccupancyTCR';          

% === PARAMETER CONFIGURATION ===
param_values =[5e-5, 0.01];
param_names = {'kon', 'koff'};

% === INITIAL CONDITIONS ===
x0 = complex([0, 100, 2e4], 0);
state_names = {'C0', 'L', 'R'};

% === STATE TO ANALYZE ===
state_index = 1;

% === TIME CONFIGURATION ===
step_size = 0.05;
t_end     = 50;
tspan     = 0.0:step_size:t_end;

% === TOLERANCES ===
rel_tol = 1e-9;                 %   Relative Tolerance.   
abs_tol = 1e-12;                %   Absolute Tolerance.

% === SOLVER AND STEP ===
solver = @ode15s;                %   Some examples: @ode15, @ode23s, @ode45...
d = 1.0e-16;

% === VISUALIZATION OPTIONS ===
visualization_choice = 2;       %   1 - Results are shown in Heatmap form, GRAY scale.
                                %   2 - Results are shown in Heatmap form, INFERNO scale.