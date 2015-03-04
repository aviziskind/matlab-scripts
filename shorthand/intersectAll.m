function c = intersectAll(varargin)
    if nargin == 1        
        args = varargin{1};
        N = length(args);
        if ~iscell(args) || N < 2
            error('If only 1 input, input must be a cell array with at least 2 elements');
        end
    else
        N = nargin;
        args = varargin;
    end

    c = args{1};
    for arg_i = 2:N
        c = intersect(c, args{arg_i});
    end

end