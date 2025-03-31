% INITIAL VALUES FOR INTEGRATION:

lista_param={[1, 0.1, 0.3, 1, 0.01, 10^-8, 1.5, 0.01, 0.1, 4.25e12, 1, 1e3, 1e8, 1e10, 5e9, 0.1, 1.0, 1e-8, 1.0, 0.01, 1e-11, 1e-12, 1e-11],{'η', 'μ_I', 'ν', 'κ', 'ϵ', 'θ', 'μ_E', 'μ_P', 'ρ', 'K', 'γ', 'A', 'B', 'C', 'σ_M', 'δ_M', 'σ_I', 'α', 'δ_I', 'g_0', 'β_B', 'β_K', 'β_C'}};

x0 = complex([1.33e6, 10, 10, 1e8, 2.5e5, 1e11, 10, 1], 0);  %([1.33e6, 0, 0, 1e8, 2.5e5, 1e11, 0, 1], 0)
    % step size and time interval in days
d = 1.0e-16; 
tspan = 0.0:0.005:50; %0.0:0.05:500
p = complex([1,                % eta (10^-8 to 30, inicial = 1)  -1
             0.1,              % mu_I ([0.1 - 10] * slope)  -2
             0.3,              % nu (-)   -3
             1.0,              % kappa ([0.1 - 10] * slope)   -4
             0.01,             % epsilon ([2 * 10^-5 - 10^-1], inicial = 10^-2)   -5
             10^-8,            % theta ([0 - 0.121], fixed = 10^-8)   -6
             1.5,              % mu_E ([0.1 - 10] * slope, mean ex = 1.5)   -7
             0.01,             % mu_P ([0.1 - 10] * slope, low ex = 0.01)   -8
             0.1,              % rho ([0.0069 - 0.255], initial = 0.1)   -9
             4.25e12,          % K (Carrying cap.)   -10
             1,                % gamma ([0.1 - 10], initial = 1)   -11
             1e3,              % A ([1 - 4.25e12], low ex = 1e3)   -12
             1e8,              % B ([1 - 1e10], high ex = 1e8)   -13
             1e10,             % C (Half-saturation, asumed range = 1e9 - 1e11, fijo = 1e10)    -14
             5e9,              % sigma_M ([10^8 - 10^10], low ex = 5e9)    -15
             0.1,              % delta_M ([0.1 - 1], low ex = 0.1)    -16
             1.0,              % sigma_I (stationary state)   -17
             1e-8,             % alpha ([10^-10 - 10^-5], low ex = 1e-8)   -18
             1.0,              % delta_I ([1 - 24], low ex = 1.0)   -19
             0.01,             % g0 ([10^-3 - 10^-1], initial = 10^-2)    -20
             1e-11,            % beta_B ([10^-13 - 10^-8], mean ex = 1e-11)    -21
             1e-12,            % beta_K ([10^-15 - 10^-10], mean ex = 1e-12)   -22
             1e-11             % beta_C ([10^-13 - 10^-8], mean ex = 1e-11)    -23
            ], 0);

SS = 8;  % Variable de Estado
iteraciones_estudio = 50;

% Crear la carpeta de salida si no existe:

output_folder = fullfile(pwd, 'img sens CRS');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

for pI = 7:23
    rango_max_param = 5 * lista_param{1}(pI);
    CARTVect = 0:rango_max_param/iteraciones_estudio:rango_max_param;

    pIndex = pI + 1;
    results_matrix = zeros(length(CARTVect), length(tspan));
    
    for i = 1:length(CARTVect)
        lista_param{1}(pI) = CARTVect(i);
        p = complex(lista_param{1}, 0);
        solution = sensitivityMain(x0, p, d, tspan, @CARTFunction);
    
        SolResponse = solution{SS}(:, pIndex); 
        newSol = (SolResponse .* CARTVect(i)) ./ solution{SS}(:, 1);
    
        results_matrix(i, :) = newSol.';  % transponer a fila
end

    % FIGURA NORMAL
    figura_normal = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    contourf(tspan, CARTVect, results_matrix, 10, 'LineColor', 'k');
    colormap(gray);
    cb = colorbar;
    cb.Label.String = 'Sensitivity';
    xlabel('Time (s)', 'FontSize', 18);
    ylabel(lista_param{2}{pI}, 'FontSize', 18, 'Rotation', 0);
    title("CRS: IL-6 sensitivity to " + lista_param{2}{pI}, 'FontSize', 18, 'FontWeight', 'bold');
    set(gca, 'YDir', 'normal');
    
    nombre_normal = fullfile(output_folder, strcat('CRS_', 'Parameter ', num2str(pI), '_State ', num2str(SS)));
    export_fig(figura_normal, nombre_normal, '-png', '-transparent');
    close(figura_normal);

    % FIGURA LOGARÍTMICA
    results_matrix_log = log10(abs(results_matrix));
    figura_log = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    contourf(tspan, CARTVect, results_matrix_log, 10, 'LineColor', 'k');
    colormap(gray);
    cb = colorbar;
    cb.Label.String = 'Sensitivity';
    xlabel('Time (s)', 'FontSize', 18);
    ylabel(lista_param{2}{pI}, 'FontSize', 18, 'Rotation', 0);
    title("CRS: IL-6 sensitivity (log) to " + lista_param{2}{pI}, 'FontSize', 18, 'FontWeight', 'bold');
    set(gca, 'YDir', 'normal');
    
    nombre_log = fullfile(output_folder, strcat('CRS_', 'Parameter ', num2str(pI), '_State ', num2str(SS), ' log'));
    export_fig(figura_log, nombre_log, '-png', '-transparent');
    close(figura_log);

    disp(['Generadas figuras para parámetro ' num2str(pI) ' / 23']);
end
