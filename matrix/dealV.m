function varargout = dealV(v)
    if (nargout ~= length(v))
        error('number of output arguments must be = length of input vector');
    end
    for i = 1:nargout
        varargout{i} = v(i);
    end
end