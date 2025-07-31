% =========================================================================
% USER OPTIONS FOR SENSITIVITY ANALYSIS
% =========================================================================

% === MODEL SELECTION ===
%   Acronym given to the model in the file in models folder
modelname     = 'HIV';          


% === PARAMETER CONFIGURATION ===

%param_values = [1, 0.1, 0.3, 1, 0.01, 10^-8, 1.5, 0.01, 0.1, 4.25e12, 1, 1e3, 1e8, 1e10, 5e9, 0.1, 1.0, 1e-8, 1.0, 0.01, 1e-11, 1e-12, 1e-11];   
%param_names = {'η', 'μ_I', 'ν', 'κ', 'ϵ', 'θ', 'μ_E', 'μ_P', 'ρ', 'K', 'γ', 'A', 'B', 'C', 'σ_M', 'δ_M', 'σ_I', 'α', 'δ_I', 'g_0', 'β_B', 'β_K', 'β_C'};

% param_values =[0.265, 0.35, 0.15, 6e-6, 4.5e-8, 0.005, 0.0565, 1.404e-12, 3.72e-6];
% param_names = {'φ', 'ρ', 'ϵ', 'θ', 'α', 'μ', 'r', 'b', 'γ'};

param_values =[0.265, 0.35, 0.15, 0.2, 0.5];
param_names = {'p1', 'p2', 'p3', 'p4', 'p5'};


% === INITIAL CONDITIONS ===
%x0 = complex([1.33e6, 10, 10, 1e8, 2.5e5, 1e11, 10, 1], 0);
%state_names = {'C_I', 'C_E', 'C_P', 'T_P', 'T_N', 'M_a', 'M_i', 'IL_6'};

x0 = complex([2e6, 0, 2e6], 0);
state_names = {'C_T', 'C_M', 'T'};

x0 = complex([1000, 0, 0], 0);
state_names = {'Tu', 'Ti', 'v'};


% === STATE TO ANALYZE ===
state_index = 3; %%%%%%%change!!

% === TIME CONFIGURATION ===
step_size = 0.005;
t_end     = 50;
tspan     = 0.0:step_size:t_end;

% === TOLERANCES ===
rel_tol = 1e-9;                 %   Relative Tolerance.   
abs_tol = 1e-12;                %   Absolute Tolerance.

% === SOLVER AND STEP ===
solver = @ode45;                %   Some examples: @ode15, @ode23s, @ode45...
d = 1.0e-16;

% === VISUALIZATION OPTIONS ===
visualization_choice = 2;       %   1 - Results are shown in Heatmap form, GRAY scale.
                                %   2 - Results are shown in Heatmap form, INFERNO scale.