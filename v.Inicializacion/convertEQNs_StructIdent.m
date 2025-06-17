clear 
clc

modelName = 'CRN.jl';

% Crear archivo para almacenar la ode de modelName
[~, nombreFuncion, ~] = fileparts(modelName);
fid = fopen(nombreFuncion + ".m", "w");
if fid == -1
    error("Parece que no funciona");
end

% Leer el contenido del archivo .jl
filetext = fileread(modelName);

% Esto construye un string que sea igual a ode = @ODEmodel( ... )sin importar
% los espacios y se queda con lo de dentro
expr = 'ode\s*=\s*@ODEmodel\s*\(([\s\S]*)';
odes = regexp(filetext, expr, 'tokens', 'dotall');

if ~isempty(odes)
    contenido_odes = odes{1}{1};
else
    error('No se encontró un bloque @ODEmodel en el archivo.');
end

% Separar las ecuaciones individuales que están separadas por comas
lineas = strsplit(contenido_odes, ',');

% 
for idx = 1:length(lineas)

    % Con esto quiero eliminar espacios en blanco, al principio o al final
    % de cada línea
    linea = strtrim(lineas{idx});
    % Si hubiera una línea vacía entre las ecuaciones
    if isempty(linea)
        continue;
    end
    
    % Reemplaza derivadas P'(t) por dPdt, T'(t) por dTdt, etc. \w+ coge el
    % nombre y lo traslada a $1
    linea = regexprep(linea, "(\w+)'\(t\)", 'd$1dt');

    % P(t) por P. Lo mismo, w contiene el nombre y lo pasa a 1
    linea = regexprep(linea, '(\w+)\(t\)', '$1');

    % Ir escribiendo de vuelta las ecuaciones en el archivo nuevo
    fprintf(fid, '%s;\n', linea);
end

% Cerrar archivo
fclose(fid);

