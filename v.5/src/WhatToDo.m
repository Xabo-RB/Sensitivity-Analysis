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
%% CONVERSION
if strcmpi(convert_model_or_RunSensitivities, 'convert')

    if isempty(modelNameJulia)
        return
    end
    convertEQNs_StructIdent(modelNameJulia)

    if isempty(modelName)
        return
    end
    symbols = load(fullfile('original_files', modelName), 'x', 'f', 'p', 'u', 'w');
    convertEQNs_SG(symbols, modelName)

    return
end

%% RUN SENSITIVITY CODE

if strcmpi(convert_model_or_RunSensitivities, 'run')
    SensitivityOrganizer
end