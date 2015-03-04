function [m, indices] = maxElement(X)
    if nargout>1
        [m,idx]= max(X(:));
        indices = ind2subV(size(X), idx);
    else
        m = max(X(:));
    end    
end
