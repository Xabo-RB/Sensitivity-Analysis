%% WhatToDo — Conversión y ejecución de sensibilidades
%
% This script manage two work flows. Should not be modified by the user.
%
%   1) Conversion:
%      - Allows raw models to be converted to a common internal format.
%      - The source files must be in the ‘original_files’ folder.
%
%   2) Run sensitivities
%      - Call the function SensitivityOrganizer to launch sensitivity routines 
%        on the prepared models.
%
%% (Not User-defined)
function WhatToDo(mode, modelNameJulia, modelName)
    
    %% CONVERSION
    if strcmpi(mode, 'convert')
    
        if ~isempty(modelNameJulia)
            convertEQNs_StructIdent(modelNameJulia)
        end
    
        if ~isempty(modelName)
            symbols = load(fullfile('original_files', modelName), 'x', 'f', 'p', 'u', 'w');
            convertEQNs_SG(symbols, modelName)
        end
    
        return
    end
    
    %% RUN SENSITIVITY CODE
    
    if strcmpi(mode, 'run')
        SensitivityOrganizer
    end

end