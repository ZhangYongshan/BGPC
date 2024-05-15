function [Z,idx,Dis,gamma] = initZ(X,A,k)
%% Init anchor graph Z.
% Input:
%       - X: data matrix
%       - A: anchor matrix.
%       - k: the number of neighbors.
% Output:
%       - Z: anchor graph
%       - distX: k smallest distance.
%       - idx: k smallest index in distX.
%       - gamma: regularization parameter
%%

n = size(X,2); % the number of samples
m = size(A,2); % the number of clustering centers.
Dis = sqdist(X, A);
% Dis1 = internal.stats.pdist2mex(X,A,'sqe',[],[],[],[]);
DISTX = Dis;
distX = zeros(n,k+1);
idx = zeros(n,k+1); 
for i = 1:k+1
    [distX(:,i),idx(:,i)] = min(DISTX, [], 2); % di: distXt min value in each row, idx: min value index
    temp = (idx(:,i)-1)*n+(1:n)';
    DISTX(temp) = 1e100;
end
clear temp
idx(:,end) = [];
Gamma = 0.5*(k*distX(:,k+1)-sum(distX(:,1:k),2));
gamma = 1*mean(Gamma);

%%
ver=version;
if(str2double(ver(1:3))>=9.1)
    tmp = (distX(:,k+1)-distX(:,1:k))./(2*Gamma+eps); % for the newest version(>=9.1) of MATLAB
else
    tmp =  bsxfun(@rdivide,bsxfun(@minus,distX(:,k+1),distX(:,1:k)),2*Gamma+eps); % for old version(<9.1) of MATLAB
end
Z = sparse(repmat((1:n),1,k),idx(:),tmp(:),n,m);

end