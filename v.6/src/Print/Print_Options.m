fprintf('\n=== ANALYSIS OPTIONS ===\n');

fprintf('Model name:\n');
fprintf('  %s\n', opts.modelname);

fprintf('Relative tolerance:\n');
fprintf('  %g\n', opts.rel_tol);

fprintf('Absolute tolerance:\n');
fprintf('  %g\n', opts.abs_tol);

fprintf('Solver:\n');
fprintf('  %s\n', func2str(opts.solver));

fprintf('d:\n');
fprintf('  %g\n', opts.d);

fprintf('Parallel computing:\n');
fprintf('  Enables\n');

fprintf('Visualization:\n');
if opts.visualization_choice == 1
    fprintf('  Heatmap in gray scale\n');
elseif opts.visualization_choice == 2
    fprintf('  Heatmap in inferno colors\n');
else
    fprintf('  Unknown visualization option (%d)\n', opts.visualization_choice);
end

if opts.ICsens
    fprintf('Sensitivity to initial conditions:\n');
    fprintf('  Enabled\n');

    fprintf('Initial condition index to analyse:\n');
    fprintf('  %d\n', opts.nStaIC);

    fprintf('Range for IC sensitivity:\n');
    fprintf('  [%g, %g]\n', opts.rango(1), opts.rango(2));
end


fprintf('\n=== SPECIFIC MODEL OPTIONS ===\n');

fprintf('Parameter values:\n');
for i = 1:length(model.param_values)
    fprintf('  %s: %g\n', model.param_names{i}, model.param_values(i));
end

fprintf('Range type: %d\n', model.range_type);

if model.range_type == 1
    fprintf('Number of samples: %d\n', model.number_samples);
    fprintf('Default ranges (3 orders below and above nominal value):\n');

    for i = 1:length(model.param_values)
        p0 = model.param_values(i);
        rango_min_param = p0 * 1e-3;
        rango_max_param = p0 * 1e3;

        fprintf('  %s: [%g, %g]\n', ...
            model.param_names{i}, rango_min_param, rango_max_param);
    end

elseif model.range_type == 2
    fprintf('Number of samples: %d\n', model.number_samples);
    fprintf('Parameter ranges:\n');
    disp(model.param_ranges)

elseif model.range_type == 3
    fprintf('Parameter ranges (cell array):\n');
    disp(model.param_ranges)
end

fprintf('Initial conditions x0: \n');
fprintf('  %g ', model.x0);
fprintf('\n');

fprintf('State names: \n');
fprintf('  %s ', model.state_names{:});
fprintf('\n');

fprintf('State index to analyze: \n   %d\n', model.state_index);

fprintf('Step size: \n   %g\n', model.step_size);
fprintf('Final time: \n   %g\n', model.t_end);
