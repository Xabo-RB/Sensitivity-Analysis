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

