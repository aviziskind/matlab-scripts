function [m, indices] = minElement(X)

    [m,idx]= min(X(:));
    indices = ind2subV(size(X), idx);

%     [m, indices] = minElements(X, 1);
    
end
