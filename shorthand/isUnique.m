function tf = isUnique(x, varargin)
    tf = length(unique(x, varargin{:})) == 1;
end