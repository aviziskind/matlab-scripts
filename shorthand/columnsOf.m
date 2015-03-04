function varargout = columnsOf(X)
    for ci = 1:size(X,2);
        varargout{ci} = X(:,ci);
    end
end