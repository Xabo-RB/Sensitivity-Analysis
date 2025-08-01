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

% === SIMULATION TIME OPTIONS === %
step_size = 0.005; 
t_end = 50; 
tspan = 0.0:step_size:t_end;

% === TOLERANCES OPTIONS === %
d = 1.0e-16;

disp('Solver tolerances:');

rel_tol_input = input('  Enter Relative Tolerance (type X for default = 1e-9): ', 's');

if strcmpi(rel_tol_input, 'X')
    rel_tol = 1e-9;
else
    rel_tol = str2double(rel_tol_input);
end

abs_tol_input = input('  Enter Absolute Tolerance (type X for default = 1e-12): ', 's');
if strcmpi(abs_tol_input, 'X')
    abs_tol = 1e-12;
else
    abs_tol = str2double(abs_tol_input);
end

% === SOLVER OPTIONS === %
disp('ODE Solver options:');
disp('  1 - ode45');
disp('  2 - ode23s');
disp('  3 - ode15s');
solver_choice = input('Select solver (1/2/3): ');

switch solver_choice
    case 1
        solver = @ode45;
    case 2
        solver = @ode23s;
    case 3
        solver = @ode15s;
    otherwise
        warning('Not valid. Defaulting to ode15s.');
        solver = @ode15s;
end

solver_name = func2str(solver);

% Iterations of the sensitivity study
iterations = 50;

% === VISUALIZATION OPTIONS === %
disp('Visualization options:');
disp('  1 - Heatmap (gray colormap)');
disp('  2 - Heatmap (inferno colormap)');
disp('  3 - Contour lines only');
vis_choice = input('Select visualization type (1/2/3): ');

disp('Sensitivity type:');
disp('  1 - Normalized (default)');
disp('  2 - Unnormalized');
sens_choice = input('Select sensitivity type (1/2): ');

% === OUTPUT FOLDER OPTIONS === %
output_folder = fullfile(pwd, ...
    ['Sensitivity_Images_' model_name '_' solver_name '_' num2str(rel_tol) '_' num2str(abs_tol)]);
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

if isempty(gcp('nocreate'))
    parpool;
end

param_values_original = param_values;
x0_real = real(x0);

% === LOOP OF PARAMETERS TO ANALIZE === %
for pI = 1:1
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
        if sens_choice == 1
            normalized = (response .* CARTVect(i)) ./ sol{state_index}(:, 1);
        else
            normalized = response;
        end
        results_matrix(i, :) = normalized.';
    end

    % FIGURE AT NORMAL SCALE
    figura_normal = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    switch vis_choice
        case 1
            contourf(tspan, CARTVect, results_matrix, 10, 'LineColor', 'k');
            colormap(gray);
        case 2
            inferno = csvread('inferno_colormap.csv');
            contourf(tspan, CARTVect, results_matrix, 10, 'LineColor', 'k');
            colormap(inferno);
        case 3
            contour(tspan, CARTVect, results_matrix, 10, 'LineColor', 'k');
    end
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
    switch vis_choice
        case 1
            contourf(tspan, CARTVect, results_matrix_log, 10, 'LineColor', 'k');
            colormap(gray);
        case 2
            inferno = csvread('inferno_colormap.csv');
            contourf(tspan, CARTVect, results_matrix_log, 10, 'LineColor', 'k');
            colormap(inferno);
        case 3
            contour(tspan, CARTVect, results_matrix_log, 10, 'LineColor', 'k');
    end

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





