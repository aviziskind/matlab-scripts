function hout = lineOrUpdateLine(h, lineX, lineY, varargin) 
    if isempty(h) || all(h(:) == 0)
        h = line(lineX, lineY, varargin{:});
    else
        for i = 1:length(h)
            set(h(i), 'xdata', lineX(:,i), 'ydata', lineY(:,i), varargin{:});
        end
    end
    if nargout > 0
        hout = h;
    end
    
end