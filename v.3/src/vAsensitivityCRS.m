% === GENERAL CONF. === %
model_name = 'CRS';
ode_function = @CRSFunction;  % función del modelo a analizar

% Parameters and respective names of the model
param_values = [1, 0.1, 0.3, 1, 0.01, 10^-8, 1.5, 0.01, 0.1, 4.25e12, 1, 1e3, 1e8, 1e10, 5e9, 0.1, 1.0, 1e-8, 1.0, 0.01, 1e-11, 1e-12, 1e-11];
param_names = {'η', 'μ_I', 'ν', 'κ', 'ϵ', 'θ', 'μ_E', 'μ_P', 'ρ', 'K', 'γ', 'A', 'B', 'C', 'σ_M', 'δ_M', 'σ_I', 'α', 'δ_I', 'g_0', 'β_B', 'β_K', 'β_C'};

% Initial values and names for the state variables
x0 = complex([1.33e6, 10, 10, 1e8, 2.5e5, 1e11, 10, 1], 0);
state_names = {'C_I', 'C_E', 'C_P', 'T_P','T_N', 'M_a', 'M_i', 'IL_6'};

% Index of the State Variable that is wanted to be studied
state_index = 8;  

% Simulation Time options
step_size = 0.005; 
t_end = 50; 
tspan = 0.0:step_size:t_end;

% Tolerances and solver
d = 1.0e-16; 
rel_tol = 1e-9;
abs_tol = 1e-12;
solver = @ode23s;  % Change for @ode45, @ode15s...

% Iterations of the sensitivity study
iterations = 50;

% Output Folder
output_folder = fullfile(pwd, ['Sensitivity_Images_' model_name '_ode23s_1e-6_1e-9']); 
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

if isempty(gcp('nocreate'))
    parpool;
end

param_values_original = param_values;
x0_real = real(x0);

% === LOOP OF PARAMETERS TO ANALIZE === %
for pI = 1:3
    tic
    rango_max_param = 5 * param_values_original(pI);
    CARTVect = linspace(0, rango_max_param, iterations);
    results_matrix = zeros(iterations, length(tspan));

    parfor i = 1:iterations  % PARALLEL LOOP
        local_params = param_values_original;
        local_params(pI) = CARTVect(i);
        p = complex(local_params, 0);
        sol = sensitivityMain(x0_real, p, d, tspan, ode_function, solver, rel_tol, abs_tol);
        response = sol{state_index}(:, pI + 1);
        normalized = (response .* CARTVect(i)) ./ sol{state_index}(:, 1);
        results_matrix(i, :) = normalized.';
    end

    % FIGURE AT NORMAL SCALE
    figura_normal = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    contourf(tspan, CARTVect, results_matrix, 10, 'LineColor', 'k');
    colormap(gray); cb = colorbar;
    cb.Label.String = 'Sensitivity';
    xlabel('Time (s)', 'FontSize', 18);
    ylabel(param_names{pI}, 'FontSize', 18, 'Rotation', 0);
    title([model_name ': Sensitivity of ' state_names{state_index} ' to ' param_names{pI}], 'FontSize', 18, 'FontWeight', 'bold');
    set(gca, 'YDir', 'normal');

    nombre_normal = fullfile(output_folder, [model_name '_Parameter_' num2str(pI) '_State_' num2str(state_index)]);
    exportgraphics(figura_normal, [nombre_normal '.png'], 'BackgroundColor','white','ContentType','image');
    close(figura_normal);

    % FIGURE AT LOGARITMIC SCALE
    results_matrix_log = log10(abs(results_matrix));
    figura_log = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    contourf(tspan, CARTVect, results_matrix_log, 10, 'LineColor', 'k');
    colormap(gray); cb = colorbar;
    cb.Label.String = 'Sensitivity';
    xlabel('Time (s)', 'FontSize', 18);
    ylabel(param_names{pI}, 'FontSize', 18, 'Rotation', 0);
    title([model_name ': Sensitivity of ' state_names{state_index} ' (log) to ' param_names{pI}], 'FontSize', 18, 'FontWeight', 'bold');
    set(gca, 'YDir', 'normal');

    nombre_log = fullfile(output_folder, [model_name '_Parameter_' num2str(pI) '_State_' num2str(state_index) '_log']);
    exportgraphics(figura_log, [nombre_log '.png'], 'BackgroundColor','white','ContentType','image');
    close(figura_log);

    disp(['Generated figures for parameter ' num2str(pI) ' out of ' num2str(length(param_values))]);
    toc
end