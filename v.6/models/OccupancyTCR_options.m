% =========================================================================
% USER OPTIONS FOR SENSITIVITY ANALYSIS
% =========================================================================        

% === PARAMETER CONFIGURATION ===
model.param_values =[5e-5, 0.01];
model.param_names = {'kon', 'koff'};

% === PARAMETER RANGE VALUES ===
model.range_type = 1;
% Choose one option:
%   1 -> default range: 3 orders of magnitude below and 3 above the nominal parameter value.
%   2 -> define [min, max] for each parameter and the number of points
%   3 -> define [min, max] for each parameter and the step size within points

if model.range_type == 1

    % How many points you would like to compute within the default range
    model.number_samples = 1000;

elseif model.range_type == 2

    model.number_samples = 1000;
    model.param_ranges = [4e-6, 2e-2; 
                          0.001, 1];

elseif model.range_type == 3

    model.param_ranges = {
        4e-6:1e-6:2e-2, ...
        0.001:0.001:1
    };

end                        

% === INITIAL CONDITIONS ===
model.x0 = [0, 100, 2e4];
model.state_names = {'C0', 'L', 'R'};

% === STATE TO ANALYZE ===
model.state_index = 1;

% === TIME CONFIGURATION ===
model.step_size = 0.05;
model.t_end     = 50;
model.tspan     = 0.0:model.step_size:model.t_end;

Print_Options
