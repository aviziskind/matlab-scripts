function [m, indices] = maxElements(varargin)

    [m, indices] = minOrMaxElements('max', varargin{:});
    
end
