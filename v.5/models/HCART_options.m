% =========================================================================
% USER OPTIONS FOR SENSITIVITY ANALYSIS
% =========================================================================        

% === PARAMETER CONFIGURATION ===
param_values =[0.265, 0.35, 0.15, 6e-6, 4.5e-8, 0.005, 0.0565, 1.404e-12, 3.72e-6];
param_names = {'φ', 'ρ', 'ϵ', 'θ', 'α', 'μ', 'r', 'b', 'γ'};
model_number_samples = 1000;

% === INITIAL CONDITIONS ===
x0 = complex([2e6, 0, 2e6], 0);
state_names = {'C_T', 'C_M', 'T'};

% === STATE TO ANALYZE ===
state_index = 3;

% === TIME CONFIGURATION ===
model.step_size = 0.05;
model.t_end     = 50;
model.tspan     = 0.0:model.step_size:model.t_end;


