clear; close all; clc;
addpath(genpath('funs'));

% Add HSI dataset path
addpath('D:\Research\datasets');

%%
dataType = 'Salinas';   
projDim = 84;   % 51 - 102

% dataType = 'PaviaU';
% projDim = 28;    % 25 - 52

% dataType = 'PaviaC';
% projDim = 38;     % 25 - 51

%%

[data3D, gt, ind, c] = loadHSI(dataType);

[y_pred, Z, A, W] = BGPC(data3D, c, projDim);

clusteringResults = evaluate_results_clustering(y_pred(ind), gt(ind));

fprintf('\n\n');
disp(clusteringResults);
