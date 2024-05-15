function [means] = meanInd(X, label, Z)

m = size(Z,2); % the number of anchors

means = zeros(size(X,1), m);
for i=1:m
    sub_idx=find(label==i);
    means(:,i)=X(:,sub_idx)*Z(sub_idx,i)/sum(Z(sub_idx,i)); % the means of the pixles in one cluster
end

means(isnan(means)) = 0;

end
