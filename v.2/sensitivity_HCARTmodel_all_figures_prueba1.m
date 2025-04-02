% INITIAL VALUES FOR INTEGRATION

lista_param={[0.265, 0.35, 0.15, 6e-6, 4.5e-8, 0.005, 0.0565, 1.404e-12, 3.72e-6],{'φ', 'ρ', 'ϵ', 'θ', 'α', 'μ', 'r', 'b', 'γ'}};

x0 = complex([2e6, 0, 2e6], 0); 
    % step size and time interval in days
d = 1.0e-16; 
tspan = 0.0:0.5:50;
p = complex([
    0.265,      % \phi (Proliferation rate of effector CAR-T cells, day^-1) - 1
    0.35,       % \rho (Reduction rate of effector CAR-T cells, day^-1) -2
    0.15,       % \epsilon (Conversion rate to memory cells, day^-1) -3
    6e-6,       % \theta (Activation coefficient, (cell*day)^-1) -4
    4.5e-8,     % \alpha (Tumor-induced immunosuppressive effect, (cell*day)^-1) -5
    0.005,      % \mu (Death rate of memory CAR-T cells, day^-1) -6
    0.0565,     % r (Tumor maximum growth rate, day^-1) -7
    1.404e-12,  % b (Inverse of tumor carrying capacity, cell^-1) -8
    3.72e-6     % \gamma (Cytotoxic coefficient, (cell*day)^-1) -9
], 0);

SS = 3; % Variable de Estado
iteraciones_estudio = 50;

% Crear la carpeta de salida si no existe:

output_folder = fullfile(pwd, 'img sens HCART');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

for pI = 1:9 % número de parámetros en el bucle
    rango_max_param = 5 * lista_param{1}(pI);
    HCARTVect = 0:rango_max_param/iteraciones_estudio:rango_max_param;

    pIndex = pI + 1;
    results_matrix = zeros(length(HCARTVect), length(tspan));
    
    for i = 1:length(HCARTVect)
        lista_param{1}(pI) = HCARTVect(i);
        p = complex(lista_param{1}, 0);
        solution = sensitivityMain(x0, p, d, tspan, @HCARTFunction);
    
        SolResponse = solution{SS}(:, pIndex); 
        newSol = (SolResponse .* HCARTVect(i)) ./ solution{SS}(:, 1);
    
        results_matrix(i, :) = newSol.';  % transponer a fila
    end

    % FIGURA NORMAL
    figura_normal = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    contourf(tspan, HCARTVect, results_matrix, 10, 'LineColor', 'k');
    colormap(gray);
    cb = colorbar;
    cb.Label.String = 'Sensitivity';
    xlabel('Time (s)', 'FontSize', 18);
    ylabel(lista_param{2}{pI}, 'FontSize', 18, 'Rotation', 0);
    title("HCART: T sensitivity to " + lista_param{2}{pI}, 'FontSize', 18, 'FontWeight', 'bold');
    set(gca, 'YDir', 'normal');
    
    nombre_normal = fullfile(output_folder, strcat('HCART', '_Parameter ', num2str(pI-1), '_State', num2str(SS)));
    export_fig(figura_normal, nombre_normal, '-png', '-transparent');
    close(figura_normal);

    % FIGURA LOGARÍTMICA
    results_matrix_log = log10(abs(results_matrix));
    figura_log = figure('Visible', 'off', 'Position', [100, 100, 600, 400]);
    contourf(tspan, HCARTVect, results_matrix_log, 10, 'LineColor', 'k');
    colormap(gray);
    cb = colorbar;
    cb.Label.String = 'Sensitivity';
    xlabel('Time (s)', 'FontSize', 18);
    ylabel(lista_param{2}{pI}, 'FontSize', 18, 'Rotation', 0);
    title("HCART: T sensitivity (log) to " + lista_param{2}{pI}, 'FontSize', 18, 'FontWeight', 'bold');
    set(gca, 'YDir', 'normal');
    
    nombre_log = fullfile(output_folder, strcat('HCART', '_Parameter', num2str(pI), '_State', num2str(SS), '_log'));
    export_fig(figura_log, nombre_log, '-png', '-transparent');
    close(figura_log);

    disp(['Generadas figuras para parámetro ' num2str(pI) ' / 23']);
end