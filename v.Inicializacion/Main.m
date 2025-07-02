clear
clc

modelName = 'HIV.mat';
modelNameJulia = 'CRN.jl';

addpath('src');

symbols = load(fullfile('original_files', modelName), 'x', 'f', 'p', 'u', 'w');

convertEQNs_SG(symbols, modelName)

convertEQNs_StructIdent(modelNameJulia)


