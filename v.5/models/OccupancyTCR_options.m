% =========================================================================
% USER OPTIONS FOR SENSITIVITY ANALYSIS
% =========================================================================        

% === PARAMETER CONFIGURATION ===
model.param_values =[5e-5, 0.01];
model.param_names = {'kon', 'koff'};
model.number_samples = 1000; % How many points you would like to compute within the range

% === INITIAL CONDITIONS ===
model.x0 = complex([0, 5e4, 2e4], 0);
model.state_names = {'C0', 'L', 'R'};

% === STATE TO ANALYZE ===
model.state_index = 1;

% === TIME CONFIGURATION ===
model.step_size = 0.05;
model.t_end     = 50;
model.tspan     = 0.0:model.step_size:model.t_end;

