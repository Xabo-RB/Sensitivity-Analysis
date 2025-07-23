clear
clc

addpath('src');
addpath('models');

%% WHICH MODEL DO YOU WANNA USE

which = input(['Select mode:\n' ...
    '  A  - Use an already existing model (in "models" folder)\n' ...
    '  SG - Implement a new model from .MAT (StrikeGoldd) file\n' ...
    '  JL - Implement a new model from StructuralIdentifiability.jl or SIAN.jl\n' ...
    'Note: Files for SG and JL may be stored in the "original_files" folder.\n' ...
    'Enter your choice (A, SG, JL): '], 's');

% --->      
%   A  - USE AN ALREADY EXISTING MODEL (in ''models'' folder)
%   SG - IMPLEMENT A NEW MODEL from .MAT (StrikeGoldd) file
%   JL - IMPLEMENT A NEW MODEL from StructuralIdentifiability.jl or SIAN.jl
% --->      
% Note: Files for SG and JL may be stored in the 'original_files' folder.
%   which = 'A';   % Existing model (models folder)
%   which = 'SG';  % New model from .mat file
%   which = 'JL';  % New model from .jl file

% If which = 'SG'
    modelName = 'HIV.mat';
% If which = 'JL'
    modelNameJulia = 'CRN.jl';

%% CODE
% USE AN ALREADY EXISTING MODEL ('models' folder)
if strcmpi(which, 'A')
    options
    Sensitivity

% IMPLEMENT A NEW MODEL, FROM .MAT (StrikeGoldd) FILE OR FROM StructuralIdentifiability.jl or SIAN.jl
% These files may be storaged in the 'original_files' folder
elseif strcmpi(which, 'SG')

    symbols = load(fullfile('original_files', modelName), 'x', 'f', 'p', 'u', 'w');
    convertEQNs_SG(symbols, modelName)

elseif strcmpi(which, 'JL')

    convertEQNs_StructIdent(modelNameJulia)

end