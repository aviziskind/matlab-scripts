function errorbarIf(varargin)
    makeErrorBars = varargin{1};
    if makeErrorBars
        errorbar(varargin{2:end});
    else
        plot(varargin{2:end});
    end

end