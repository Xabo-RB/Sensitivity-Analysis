% === GENERAL CONF. === %
model_name = 'HCART';
ode_function = @HCARTFunction;  % funciónd del modelo a analizar

% Parameters and respective names of the model
param_values = [0.265, 0.35, 0.15, 6e-6, 4.5e-8, 0.005, 0.0565, 1.404e-12, 3.72e-6];
param_names = {'φ', 'ρ', 'ϵ', 'θ', 'α', 'μ', 'r', 'b', 'γ'};

% Initial values and names for the state variables
x0 = complex([2e6, 0, 2e6], 0);
state_names = {'C_T','C_M', 'T'};

% Index of the State Variable that is wanted to be studied
state_index = 3;  

% Simulation Time options
step_size = 0.005; 
t_end = 50; 
tspan = 0.0:step_size:t_end;

% Tolerances and solver
d = 1.0e-16; 
rel_tol = 1e-9;
abs_tol = 1e-12;
solver = @ode45;  % Change for @ode45, @ode15s...

% Iterations of the sensitivity study
iterations = 50;

% Output Folder
output_folder = fullfile(pwd, ['Sensitivity_Images_' model_name '_ode45']); 
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

if isempty(gcp('nocreate'))
    parpool;
end

param_values_original = param_values;
x0_real = real(x0);

% === LOOP OF PARAMETERS TO ANALIZE === %
for pI = 1:9
    tic
    rango_max_param = 5 * param_values_original(pI);
    CARTVect = linspace(0, rango_max_param, iterations);
    results_matrix = zeros(iterations, length(tspan));

    parfor i = 1:iterations  % PARALLEL LOOP
        local_params = param_values_original;
        local_params(pI) = CARTVect(i);
        p = complex(local_params, 0);
        sol = sensitivityMain1(x0_real, p, d, tspan, ode_function, solver, rel_tol, abs_tol);
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