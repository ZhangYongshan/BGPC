function [X_temp] = findConstruct(X,index,k)
    if index==0
        index=X;
    end
    if k>=size(X,1)
        k=size(X,1)-1;
    end
    [n m] = size(X);
    X_temp = zeros(n,m);
    for i=1:n
        dd=EuDist2(index(i,:),index);
        [~,ids]=sort(dd);
        dd=EuDist2(X(i,:),X(ids(2:k+1),:));
        temp_x = X(ids(2:k+1),:);
        temp_dd = dd;
        if (sum(temp_dd==0)==k-1)
            X_temp(i,:) = X(i,:);
        else
            temp_w = exp(-dd.^2/(2*mean(dd))^2);
            temp_w = temp_w/sum(temp_w);
            X_temp(i,:) = temp_w*temp_x;
        end
    end
end