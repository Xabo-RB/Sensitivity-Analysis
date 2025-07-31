% =========================================================================
% USER OPTIONS FOR SENSITIVITY ANALYSIS
% =========================================================================        

% === PARAMETER CONFIGURATION ===
param_values =[0.265, 0.35, 0.15, 6e-6, 4.5e-8, 0.005, 0.0565, 1.404e-12, 3.72e-6];
param_names = {'φ', 'ρ', 'ϵ', 'θ', 'α', 'μ', 'r', 'b', 'γ'};

% === INITIAL CONDITIONS ===
x0 = complex([2e6, 0, 2e6], 0);
state_names = {'C_T', 'C_M', 'T'};

% === STATE TO ANALYZE ===
state_index = 3;

% === TIME CONFIGURATION ===
step_size = 0.05;
t_end     = 50;
tspan     = 0.0:step_size:t_end;

