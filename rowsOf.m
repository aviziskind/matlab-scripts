function varargout = rowsOf(X)
    for ri = 1:size(X,1);
        varargout{ri} = X(ri,:);
    end
end