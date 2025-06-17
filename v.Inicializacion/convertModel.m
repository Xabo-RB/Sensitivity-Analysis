clear
clc

modelName = 'HIV.mat';

symbols = load(modelName, 'x','f','p','u','w');

convertEQNs_SG(symbols, modelName)

%% Si lo hago desde este archivo

% % Crear archivo para almacenar la ode
% [~, nombreFuncion, ~] = fileparts(modelName);
% fid = fopen(nombreFuncion + ".m", "w");
% if fid == -1
%     error("Prarece que no funciona");
% end
% 
% % Si No hay ni entradas conocidas ni desconocidas
% if isempty(symbols.u) && isempty(symbols.w)
%     fprintf(fid, "function dx = %s(t, x, p)\n", nombreFuncion);
%     fprintf(fid, "    dx = zeros(%d,1);\n", numel(newEQNS));
%     fprintf(fid, "\n");
% 
%     for i = 1:numel(newEQNS)
%         ecuacion = char(newEQNS(i));
%         fprintf(fid, "    dx(%d) = %s;\n", i, ecuacion);
%     end
%     fprintf(fid, "end\n");
% % Si hay entradas conocidas o desconocidas
% else 
% 
%     if ~isempty(symbols.u) && isempty(symbols.w)
%         ustring = string(symbols.u);
%         oracionUs = strjoin(ustring, ", ");
%         oracionUs = char(oracionUs);
%     elseif ~isempty(symbols.w) && isempty(symbols.u)
%         ustring = string(symbols.w);
%         oracionUs = strjoin(ustring, ", ");
%         oracionUs = char(oracionUs);
%     end
% 
%     fprintf(fid, "function dx = %s(t, x, p, %s)\n", nombreFuncion, oracionUs);
%     fprintf(fid, "    dx = zeros(%d,1);\n", numel(newEQNS));
%     fprintf(fid, "\n");
% 
%     for i = 1:numel(newEQNS)
%         ecuacion = char(newEQNS(i));
%         fprintf(fid, "    dx(%d) = %s;\n", i, ecuacion);
%     end
% 
%     fprintf(fid, "end\n");
% 
% end
% 
% fclose(fid);


