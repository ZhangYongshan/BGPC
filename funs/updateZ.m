function [Z] = updateZ(X,A,k,gamma,lambda,FD1,FD2)
%% Update anchor graph Z
% Input:
%       - X:        data matrix, d by n, each column is a sample
%       - A:        anchor, d by m
%       - k:        the number of neighbor points
%       - gamma:    regularization parameter
%       - lambda:   rank constraint parameter
%       - FD1:      D1*U
%       - FD2:      D2*V
% Output:
%       - Z:        new anchor graph.
%%

[~,idx,distX,~] = initZ(X,A,k);

n = size(X,2);
m = size(A,2);
dxi = zeros(n,k); % knn of samples in centers
tmp1 = zeros(n,k); 
for i = 1:n
    dxi(i,:) = distX(i,idx(i,:));
end
distF = sqdist(FD1',FD2');

for i = 1:n
    dfi = distF(i,idx(i,:));
    ad = -(dxi(i,:)+lambda*dfi)/(2*gamma);   
    tmp1(i,:) = EProjSimplex_new(ad);
end

Z = sparse(repmat((1:n),1,k),idx(:),tmp1(:),n,m);

Z(isnan(Z)) = 0;

end