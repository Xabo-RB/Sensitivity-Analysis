% =========================================================================
% USER OPTIONS FOR SENSITIVITY ANALYSIS
% =========================================================================        

% === PARAMETER CONFIGURATION ===
model.param_values = [1, 0.1, 0.3, 1, 0.01, 10^-8, 1.5, 0.01, 0.1, 4.25e12, 1, 1e3, 1e8, 1e10, 5e9, 0.1, 1.0, 1e-8, 1.0, 0.01, 1e-11, 1e-12, 1e-11];   
model.param_names = {'η', 'μ_I', 'ν', 'κ', 'ϵ', 'θ', 'μ_E', 'μ_P', 'ρ', 'K', 'γ', 'A', 'B', 'C', 'σ_M', 'δ_M', 'σ_I', 'α', 'δ_I', 'g_0', 'β_B', 'β_K', 'β_C'};

% === INITIAL CONDITIONS ===
model.x0 = complex([1.33e6, 10, 10, 1e8, 2.5e5, 1e11, 10, 1], 0);
model.state_names = {'C_I', 'C_E', 'C_P', 'T_P', 'T_N', 'M_a', 'M_i', 'IL_6'};

% === STATE TO ANALYZE ===
model.state_index = 1;

% === TIME CONFIGURATION ===
model.step_size = 0.05;
model.t_end     = 50;
model.tspan     = 0.0:step_size:t_end;

