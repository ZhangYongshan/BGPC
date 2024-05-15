function [y_pred, Z, A, W] = BGPC(data3D, c, r)
%%
% Input:
%       - data3D: 3D HSI data
%       - c: cluster number.
%       - r: projection dimension
% Output:
%       - y_pred: clustering labels.
%       - Z: bipartite graph, n by m
%       - A: anchor matrix
%       - W: projection matrix


%% Weighted Local Region Denoising
disp('====Weighted Local Region Denoising');

[~,~,dim] = size(data3D);
data3D = data3D./max(data3D(:));

m = pixelNum(data3D, 2000); % Number of superpixels
splabels = cubseg(data3D, m);% ERS segmentation.

[newData] = S3_PCA(data3D, 13, splabels);

X = reshape(newData, [], dim);
X = X';



%% Bipartite Graph-based Projected Clustering
disp('====Bipartite Graph-based Projected Clustering');

k = 5;

% init anchor matrix A.
A = meanInd(X, splabels(:), ones(size(X,2),m));

St = X * X';

for i = 1 : 3
    
    [Z,~,~,gamma] = initZ(X, A, k);
    lambda = gamma;
    
    % init F.
    [~,U,V,~,D1,D2] = svd2uv(Z, c);
    
    for j = 1 : 30
        
        % update projection matrix W.
        Q = St - 2*X*Z*A' + A*diag(sum(Z))*A';
        Q = (Q+Q')/2;
        M = St\Q;
        M(isnan(M)) = 0;
        W = eig1(M,r,0,0);
        W = W*diag(1./sqrt(diag(W'*W)));
        
        [Z] = updateZ(W'*X, W'*A, k, gamma, lambda, D1*U, D2*V);

        % update F
        [~,U,V,~,D1,D2] = svd2uv(Z, c);
        
        [clusternum, ~] = struG2la(Z);
        if clusternum < c % the number of block is less than c
            lambda = 2*lambda;
        elseif clusternum > c % the number of block is more than c
            lambda = lambda/2;
        else
            break;
        end
    end
    
    % update anchor matrix A.
    [~,subLabel] = max(Z,[],2);
    [A] = meanInd(X, subLabel, Z);
    
    fprintf('%2d,',j);
    
end

[clusternum, y_pred] = struG2la(Z);

if clusternum ~= c
    fprintf('\ncluster=%d ~= c \n' ,clusternum);
    warning('The connected components do not satisfy the requirement. Please try different parameters!');
end

end

function [num]=pixelNum(data,Tbase)
%% Adaptively determine the number of superpixels
    [M,N,B]=size(data);
    Y_scale=scaleForSVM(reshape(data,M*N,B));
    p=1;
    [Y_pca] = pca(Y_scale, p);
    img = im2uint8(mat2gray(reshape(Y_pca', M, N, p)));
    [m,n] = size(img);
    BW = edge(img,'log');
    ind = find(BW~=0);
    Len = length(ind);
    Ratio = Len/(m*n);
    num = fix(Ratio * Tbase);
    
    fprintf('Superpixels number : %d\n', num);
end
