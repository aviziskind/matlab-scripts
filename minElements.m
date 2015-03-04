function [m, indices] = minElements(varargin)

    [m, indices] = minOrMaxElements('min', varargin{:});
    
end
