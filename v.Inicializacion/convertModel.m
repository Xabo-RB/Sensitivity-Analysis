clear
clc

modelName = 'HIV.mat';

symbols = load(modelName, 'x','f','p','u','w');

newEQNS = convertEQNs(symbols)




