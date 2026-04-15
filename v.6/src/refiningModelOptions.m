function [model, opts] = refiningModelOptions(model, opts)

    model.tspan     = 0.0:model.step_size:model.t_end;
    
    % CONVERT STATE NAME TO INDEX
    model.state_index = find(strcmpi(model.state_to_analyze, model.state_names), 1);
    
    if isempty(model.state_index)
        error('state_to_analyze must match one of model.state_names.');
    end
    
    opts.nStaIC = find(strcmpi(opts.IC_to_analyze, model.state_names), 1);
    
    if isempty(opts.nStaIC)
        error('IC_to_analyze must match one of model.state_names.');
    end
    
    nParams = numel(model.param_values);
    
    switch lower(model.param_range_mode)
    
        case 'default_orders'
    
            model.range_type     = 1;
            model.number_samples = model.param_range_npoints;
    
        case 'minmax_npoints'
    
            model.range_type     = 2;
            model.number_samples = model.param_range_npoints;
    
            model.param_ranges = [model.param_range_min(:), model.param_range_max(:)];
    
        case 'custom_step'
            model.range_type = 3;
    
            model.param_ranges = cell(nParams, 1);
            for i = 1:nParams
                model.param_ranges{i} = model.param_range_min(i):model.param_range_step(i):model.param_range_max(i);
            end
    
        otherwise
            error('Unknown param_range_mode. Use: default_orders, minmax_npoints or custom_step.');
    end
    
    switch lower(model.IC_range_mode)
    
        case 'default_factor'
    
            model.range_typeICs     = 1;
            model.number_samplesICs = model.IC_npoints;
    
        case 'minmax_npoints'
            model.range_typeICs     = 2;
            model.number_samplesICs = model.IC_npoints;
    
            if strcmpi(model.IC_spacing, 'log')
                if model.IC_min <= 0 || model.IC_max <= 0
                    error('Log spacing for ICs requires positive limits.');
                end
                model.param_rangesICs = logspace(log10(model.IC_min), log10(model.IC_max), model.number_samplesICs);
            else
                model.param_rangesICs = linspace(model.IC_min, model.IC_max, model.number_samplesICs);
            end
    
            model.ICs_ranges = [model.IC_min, model.IC_max];
    
        case 'custom_step'
            model.range_typeICs = 3;
    
            model.param_rangesICs   = model.IC_min:model.IC_step:model.IC_max;
            model.number_samplesICs = numel(model.param_rangesICs);
            model.ICs_ranges        = [model.IC_min, model.IC_max];
    
        otherwise
            error('Unknown IC_range_mode. Use: default_factor, minmax_npoints or custom_step.');
    end

end