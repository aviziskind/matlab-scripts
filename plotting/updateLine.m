function h_out = updateLine(h, varargin)

%{
    eg first time, call:
        h_line = updateTitle([], X, Y, 'linestyle', ':')
    next time (to update), call:
        h_line = updateText(h_line, X2, Y2, 'linestyle', '--')
%}    
    syntaxPossibilities = {{'numeric', 'numeric'}, {'xdata', 'ydata'}};

    h_out_tmp = updateHGFunction(@line, h, syntaxPossibilities, varargin{:});    
    if nargout > 0
        h_out = h_out_tmp;
    end        

end