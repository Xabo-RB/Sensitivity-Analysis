% =========================================================================
% USER OPTIONS FOR SENSITIVITY ANALYSIS
% =========================================================================        

% === PARAMETER CONFIGURATION ===
model.param_values =[0.5, 0.5, 2, 1];
model.param_names = {'k1e', 'k12', 'k21', 'b'};

% === STATE CONFIGURATION ===
model.state_names = {'x1', 'x2'};
model.x0 = [0.5, 0.5];

% === STATE TO ANALYZE ===
model.state_to_analyze = 'x1';

% === TIME CONFIGURATION ===
model.step_size = 0.05;
model.t_end     = 50;
% Time interval
model.tspan     = 0.0:model.step_size:model.t_end;

% === INPUTS ===
model.ifU1 = true;
model.u1 = model.tspan;

% === PARAMETER RANGE SETTINGS ===
% Available modes:
%   'default_orders'  -> 3 orders of magnitude below and above nominal value
%   'minmax_npoints'  -> define [min,max] and number of points
%   'custom_step'     -> define [min,max] and step size
model.param_range_mode = 'default_orders';

% One value per parameter, in the same order as model.param_names.
% 'default_orders' just use param_range_npoints.
model.param_range_min    = [4e-6,  1e-3];
model.param_range_max    = [2e-2,  1];
model.param_range_step   = [1e-6,  1e-3]; % used only in 'custom_step'
model.param_range_npoints = 200;   % used only in 'default_orders' and 'minmax_npoints'

% === INITIAL CONDITIONS RANGE VALUES ===
opts.IC_to_analyze = 'x1';
% Available modes:
%   'default_factor'  -> 3 orders of magnitude below and above nominal value
%   'minmax_npoints'  -> define [min,max] and number of points
%   'custom_step'     -> define [min,max] and step size
model.IC_range_mode = 'default_factor';

model.IC_min      = 0;
model.IC_max      = 2e4;
model.IC_step     = 200;
model.IC_npoints  = 1000;   % used only in 'default_factor' and 'minmax_npoints'

% Spacing for 'minmax_npoints': 'linear' or 'log'
model.IC_spacing = 'linear';

[model, opts] = refiningModelOptions(model, opts);

% ==========================

Print_Options
