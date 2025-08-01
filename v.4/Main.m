clear
clc

addpath('src');
addpath('models');

%% USER-DEFINED

convert_model_or_RunSensitivities = 'run'; % 'convert' or 'run'

% ---------------------------------------------------------------
% -------------- CONVERT A MODEL TO LATTER ANALYSE --------------
% ---------------------------------------------------------------

% CONVERT A JULIA MODEL FROM StructuralIdentifiability and SIAN packages
% : https://github.com/SciML/StructuralIdentifiability.jl
% : https://github.com/alexeyovchinnikov/SIAN-Julia

    % Example:
    % modelNameJulia = 'CRN.jl';
    modelNameJulia = [];

% CONVERT A MATLAB MODEL FROM STRIKE-GOLDD package
% : https://github.com/afvillaverde/strike-goldd

    % Example:
    % modelName = 'HIV.mat';
    modelName = [];

%%

WhatToDo

