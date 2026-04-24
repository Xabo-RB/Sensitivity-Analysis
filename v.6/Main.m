%% MAIN — Model conversion and/or sensitivity launch
% Defines which action to execute ("convert" or "run”), and allows you to specify the 
% source models to be converted for further analysis.
%
% Folders:
%   ./src               -> auxiliar functions
%   ./models            -> models already converted to Matlab
%
% ---------------------------------------------------------------
% -------------- CONVERT A MODEL TO LATTER ANALYSE --------------
% ---------------------------------------------------------------
%
% The files to be converted must be in the original_files folder.
% -
% CONVERT A JULIA MODEL FROM StructuralIdentifiability and SIAN packages
% : https://github.com/SciML/StructuralIdentifiability.jl
% : https://github.com/alexeyovchinnikov/SIAN-Julia
% - 
% CONVERT A MATLAB MODEL FROM STRIKE-GOLDD package
% : https://github.com/afvillaverde/strike-goldd
% -
%%

clear
clc

addpath('src');
addpath('src/Print');
addpath('models');

%% USER-DEFINED

% Test previo de tiempos e integradores: probar todos los integradores
% existentes de Matlab y comprobar los tiempos de integración y exactitud.
Test = false;
if Test
    results = FirstTest();
    return
end


% Model conversion and/or sensitivity launch: 'convert' or 'run'
mode = 'run'; 

% If 'convert' is selected:
% Example:
% modelNameJulia = 'CRN.jl';
modelNameJulia = [];

% Example:
% modelName = 'HIV.mat';
modelName = [];

%%

WhatToDo(mode, modelNameJulia, modelName)
