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
addpath('models');

%% USER-DEFINED

convert_model_or_RunSensitivities = 'run'; % 'convert' or 'run'

    % Example:
    % modelNameJulia = 'CRN.jl';
    modelNameJulia = [];

    % Example:
    % modelName = 'HIV.mat';
    modelName = [];

%%

WhatToDo

