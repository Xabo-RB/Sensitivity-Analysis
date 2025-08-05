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