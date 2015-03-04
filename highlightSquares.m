function hLinesOut = highlightSquares(xs,ys, varargin)
    % either input:
    %   (a)  1 x and 1 y value
    %   (b)  a row, consisting of multiple xs (or empty for entire row) and 1 y
    %   (c)  a column, consisting of multiple ys (or empty for entire row) and 1 x 
        
    
    hc = get(gca, 'children');

    if isempty(xs)
        xs = get(hc(end), 'xdata');
    end
    xends = [min(xs)-0.5, max(xs)+0.5];

    if isempty(ys)
        ys = get(hc(end), 'ydata');
    end
    yends = [min(ys)-0.5, max(ys)+0.5];
            
    hLines = drawBox([xends(1), yends(1)],  [xends(2), yends(2)]);
    if nargin > 2
        set(hLines, varargin{:});
    end
    
    if nargout > 0
        hLinesOut = hLines;
    end

end