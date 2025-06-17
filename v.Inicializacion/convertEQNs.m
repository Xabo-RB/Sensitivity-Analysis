function  convertEQNs(variables, modelName)

    % ECUACIONES
    nEQ = length(variables.f);
    NewEQstring = strings(nEQ,1);
    EQstring = string(variables.f);
    
    % ------------------------------------------------------------
    % ------------------------ PARÁMETROS ------------------------
    % ------------------------------------------------------------
    
    nP = length(variables.p);
    pStrings = strings(nP, 1);
    ParamsString = string(variables.p);
    
    for i = 1:nP
        % Creo un vector con los parámetros p(i), desde i = 1 hasta nP
        pStrings(i) = "p(" + string(i) + ")"; 
    end
    
    % Reemplazo los parámetros en orde por p(i), cada parámetro se corresponde
    % con el ordendado en 'p': [k1, k2] -> [p(1), p(2)]
    for j = 1:nEQ
        newE = EQstring(j);
        for i = 1:nP
    
            obj = ParamsString(i);
            newE = replace(newE, obj, pStrings(i));
    
        end
        NewEQstring(j) = newE;
    end
    
    % ------------------------------------------------------------
    % ------------------------ ESTADOS ------------------------
    % ------------------------------------------------------------
    
    nX = length(variables.x);
    xStrings = compose("x(%d)", 1:nX);
    EstadosString = string(variables.x);
    NewEQstringXX = strings(nEQ,1);
    
    for j = 1:nEQ
        newE = NewEQstring(j);
        for i = 1:nX
    
            obj = EstadosString(i);
            newE = replace(newE, obj, xStrings(i));
    
        end
        NewEQstringXX(j) = newE;
    end
    
    
    
    % ------------------------------------------------------------
    % ------------------------ ENTRADAS ------------------------
    % ------------------------------------------------------------
    
    % Si no está vacía
    if ~isempty(variables.u)
        
        nU = length(variables.u);
        entradasStrings = string(variables.u);
        uStrings = compose("u%d", 1:nU);
        NewEQstringU = strings(nEQ,1);
        
        for j = 1:nEQ
            newE = NewEQstringXX(j);
            for i = 1:nU
        
                obj = entradasStrings(i);
                newE = replace(newE, obj, uStrings(i));
        
            end
            NewEQstringU(j) = newE;
        end
    end
    if ~isempty(variables.w)
        
        nU = length(variables.w);
        entradasStrings = string(variables.w);
        uStrings = compose("u%d", 1:nU);
        NewEQstringU = strings(nEQ,1);
        
        for j = 1:nEQ
            newE = NewEQstringXX(j);
            for i = 1:nU
        
                obj = entradasStrings(i);
                newE = replace(newE, obj, uStrings(i));
        
            end
            NewEQstringU(j) = newE;
        end
    end

    % Crear archivo para almacenar la ode
    [~, nombreFuncion, ~] = fileparts(modelName);
    fid = fopen(nombreFuncion + ".m", "w");
    if fid == -1
        error("Prarece que no funciona");
    end
    
    % Si No hay ni entradas conocidas ni desconocidas
    if isempty(variables.u) && isempty(variables.w)
        fprintf(fid, "function dx = %s(t, x, p)\n", nombreFuncion);
        fprintf(fid, "    dx = zeros(%d,1);\n", numel(newEQNS));
        fprintf(fid, "\n");
    
        for i = 1:numel(newEQNS)
            ecuacion = char(newEQNS(i));
            fprintf(fid, "    dx(%d) = %s;\n", i, ecuacion);
        end
        fprintf(fid, "end\n");
    % Si hay entradas conocidas o desconocidas
    else 
        
        if ~isempty(variables.u) && isempty(variables.w)
            % uStrings: vector con u1, u2, u3, ...
            oracionUs = strjoin(uStrings, ", ");
            oracionUs = char(oracionUs);
        elseif ~isempty(variables.w) && isempty(variables.u)
            oracionUs = strjoin(uStrings, ", ");
            oracionUs = char(oracionUs);
        end
    
        fprintf(fid, "function dx = %s(t, x, p, %s)\n", nombreFuncion, oracionUs);
        fprintf(fid, "    dx = zeros(%d,1);\n", numel(NewEQstringU));
        fprintf(fid, "\n");
        
        for i = 1:numel(NewEQstringU)
            ecuacion = char(NewEQstringU(i));
            fprintf(fid, "    dx(%d) = %s;\n", i, ecuacion);
        end
    
        fprintf(fid, "end\n");
    
    end
    
    fclose(fid);


end