function convertEQNs_StructIdent(modelName)

    %   modelName = 'CRN.jl';
    
    % Crear archivo para almacenar la ode de modelName
    [~, nombreFuncion, ~] = fileparts(modelName);
    rutaArchivo = fullfile('models', [nombreFuncion, '.m']);
    fid = fopen(rutaArchivo, "w");
    if fid == -1
        error("Parece que no funciona");
    end
    
    % Leer el contenido del archivo .jl
    filetext = fileread(fullfile('original_files', modelName));
    
    % Esto construye un string que sea igual a ode = @ODEmodel( ... )sin importar
    % los espacios y se queda con lo de dentro
    expr = 'ode\s*=\s*@ODEmodel\s*\(([\s\S]*)';
    odes = regexp(filetext, expr, 'tokens', 'dotall');
    
    if ~isempty(odes)
        contenido_odes = odes{1}{1};
    else
        error('No se encontró un bloque @ODEmodel en el archivo.');
    end
    
    % Separar las ecuaciones individuales que están separadas por saltos de
    % línea
    % lineas = strsplit(contenido_odes, ','); Esta era por comas
    lineas = regexp(contenido_odes, '\r?\n', 'split');
    
    % Eliminar celdas vacías (cadenas vacías o solo espacios). cellfun aplica
    % esa lógica a cada elemento de líneas. isempty marca true cuando está
    % vacía; entonces true son las celdas vacías, luego lo invierto con ~ y son
    % true las que no están vacías. Poniéndolo dentro de lineas(...) entonces
    % elimina los elementos que son false.
    lineas = lineas(~cellfun(@(x) isempty(strtrim(x)), lineas));
    
    % Buscar el índice de la primera línea que empieza por 'y' (ignorando espacios iniciales)
    idx = find(cellfun(@(x) ~isempty(regexp(strtrim(x), '^y\d+', 'once')), lineas), 1);
    if ~isempty(idx)
         % Eliminar desde ese índice hasta el final
        lineas(idx:end) = [];
    end
    
    vars = cell(size(lineas));
    for i = 1:length(lineas)
        linea = strtrim(lineas{i});
        % Busca la variable antes del apóstrofe y (t)
        %  Captura el nombre de la variable:  
        %                      - empieza con una letra `[a-zA-Z]`  
        %                      - seguido de letras, números o guiones bajos `[a-zA-Z0-9_]*`  
        %                       → carácter apóstrofe literal (derivada) 
        nombres = regexp(linea, "^([a-zA-Z][a-zA-Z0-9_]*)'\(t\)\s*=", 'tokens', 'once');
        if ~isempty(nombres)
            % Guarda solo el nombre, sin apóstrofe
            vars{i} = nombres{1}; 
        else
            vars{i} = '';
        end
    end
    
    % arrayfun aplica una función a cada elemento de una matriz. 
    % Función: toma un índice k y devuelve la cadena 'x(k)'
    reemplazos = arrayfun(@(k) sprintf('x(%d)', k), 1:numel(vars), 'UniformOutput', false);
    lineas_nuevas = lineas;
    
    for i = 1:numel(vars)
        % Construir patrón x1\(t\)
        patron = [vars{i} '\(t\)'];
        % Aplica en cada elemento de lineas_nuevas la substitución de patron ->
        % reemplazos.
        lineas_nuevas = cellfun(@(str) regexprep(str, patron, reemplazos{i}), lineas_nuevas, 'UniformOutput', false);
    end
    
    reemplazos = arrayfun(@(k) sprintf('dx(%d)', k), 1:numel(vars), 'UniformOutput', false);
    derivs = cellfun(@(v) [v, '''\(t\)'], vars, 'UniformOutput', false); 
    lineas_nuevas1 = lineas_nuevas;
    
    for i = 1:numel(vars)
        lineas_nuevas1 = cellfun(@(str) regexprep(str, derivs{i}, reemplazos{i}), lineas_nuevas1, 'UniformOutput', false);
    end
    
    % Así defino que son cell
    parametros = {}; 
    inputs = {};   
    
    for i = 1:numel(lineas_nuevas1)
        linea = lineas_nuevas1{i};
    
        % Elimino el lado derecho, si no hubiera no pasa nada, seguimos!
        ladoDcho = regexp(linea, '=\s*(.*?)[,;]?$', 'tokens', 'once');
        if isempty(ladoDcho), continue; end
        rhs = ladoDcho{1};

        % Encuentra inputs del tipo nombre(t)
        inp = regexp(rhs, '\<([a-zA-Z]\w*)\(t\)', 'tokens');
        inp = [inp{:}];
        inputs = [inputs, inp];
    
        % Encuentra todas las palabras que no sean x y no estén seguidas de un paréntesis
        ids = regexp(rhs, '\<([a-zA-Z]\w*)\>', 'tokens');
        % Pasa de ser un array de cells, a un único cell array 
        ids = [ids{:}];
        % Añade los parámetros encontrados en 'linea' a la lista de parámetros,
        % pueden estar repetidos
        parametros = [parametros, ids];
        

    end
    
    % Quitar duplicados
    parametros = unique(parametros);
    inputs   = unique(inputs);
    
    % Eliminar las funciones típicas, 'x', y los inputs
    funciones = {'sin','cos','tan','exp','log','sqrt','abs','min','max','sum','mod','t'};
    parametros = setdiff(parametros, [funciones, {'x'}, inputs]);
    
    % Crea la cell que va a contener p(1), p(2) hasta p(nºpams)
    reemplazos_param = arrayfun(@(k) sprintf('p(%d)', k), 1:numel(parametros), 'UniformOutput', false);
    lineas_nuevas2 = lineas_nuevas1; 
    
    
    for i = 1:numel(lineas_nuevas2)
        linea = lineas_nuevas2{i};
        for j = 1:numel(parametros)
    
            % \\ asegura coincidencia exacta del nombre.
            nombreParam = sprintf('\\<%s\\>', parametros{j});
            linea = regexprep(linea, nombreParam, reemplazos_param{j});
    
        end
        lineas_nuevas2{i} = linea;
    end
    
    % Elimina (t), denería quedar sólo los restantes de los inputs
    lineas_nuevas2 = cellfun(@(str) regexprep(str, '\(t\)', ''), lineas_nuevas2, 'UniformOutput', false);

    nVars = numel(lineas_nuevas2);

    % Este es el string con las entradas escritas unidas con coma, para
    % luego poner en el nombre de la función
    inputs_str = strjoin(inputs, ', '); 

    % Construir cabecera de función según si hay o no inputs
    if isempty(inputs)
        fprintf(fid, 'function dx = %s(t, x, p)\n', nombreFuncion);
    else
        fprintf(fid, 'function dx = %s(t, x, p, %s)\n', nombreFuncion, inputs_str);
    end
    
    fprintf(fid, '    dx = zeros(%d,1);\n', nVars);
    
    for i = 1:nVars
        % Quita coma final y añade punto y coma
        linea = regexprep(lineas_nuevas2{i}, ',$', ';');
        % Indenta y escribe la línea
        fprintf(fid, '    %s\n', linea);
    end
    
    fprintf(fid, 'end\n');
    fclose(fid);

end
% % lineas es un vector de cells, cada cell contiene un string con cada
% % ecuación.
% vars = {};
% for idx = 1:length(lineas)
% 
%     % Con esto quiero eliminar espacios en blanco, al principio o al final
%     % de cada línea
%     linea = strtrim(lineas{idx});
%     % Si hubiera una línea vacía entre las ecuaciones
%     if isempty(linea)
%         continue;
%     end
% 
%     % Si la línea es solo un paréntesis de cierre, detenemos el bucle
%     % entonces se deja de escribir el resto.
%     % if strcmp(linea, ')')
%     %     break;
%     % end
%     % if ~isempty(regexp(linea, '^y\d+\s*\(', 'once'))
%     %     break;
%     % end
% 
%     [var,~] = regexp(linea, '^(\w+)\s*=', 'tokens', 'match');
% 
%     if ~isempty(var)
%         varname = var{1}{1};
%         if ~ismember(varname, vars)
%             vars{end+1} = varname;
%         end
%     end
% end
% 
% n_vars = numel(vars);
% n_lineas = numel(lineas);
% lineas_nuevas = cell(size(lineas));
% 
% for i = 1:n_lineas
%     linea = lineas{i};
%     for v = 1:n_vars
%         varname = vars{v};
%         % Solo sustituye si NO está a la izquierda del '='
%         % Primero sustituimos apariciones con paréntesis (como S(t))
%         linea = regexprep(linea, [varname '\(([^)]*)\)'], ['x(' num2str(v) ')($1)']);
%         % Luego, sustituimos el nombre solo si es una palabra aislada y NO está a la izquierda del '='
%         linea = regexprep(linea, ['(?<!=\s*)\b' varname '\b'], ['x(' num2str(v) ')']);
%     end
%     % Ahora cambia la variable a la izquierda del '='
%     linea = regexprep(linea, '^(\w+)', ['x(' num2str(find(strcmp(vars,regexp(linea,'^(\w+)', 'tokens', 'once'){1}))) ')']);
%     % Opcional: cambiar ',' al final por ';'
%     linea = regexprep(linea, ',$', ';');
%     if ~endsWith(linea, ';')
%         linea = [linea ';'];
%     end
%     lineas_nuevas{i} = ['    ' linea];
% end
% 

%     % Reemplaza derivadas P'(t) por dPdt, T'(t) por dTdt, etc. \w+ coge el
%     % nombre y lo traslada a $1
%     linea = regexprep(linea, "(\w+)'\(t\)", 'd$1dt');
% 
%     % dxNdt --> dx(N)
%     linea = regexprep(linea, '^dx(\d+)dt', 'dx($1)');
% 
%     % P(t) por P. Lo mismo, w contiene el nombre y lo pasa a 1
%     linea = regexprep(linea, '(\w+)\(t\)', '$1');
% 
%     % Ir escribiendo de vuelta las ecuaciones en el archivo nuevo
%     fprintf(fid, '%s\n', linea);
% 
% % Cerrar archivo
% fclose(fid);

