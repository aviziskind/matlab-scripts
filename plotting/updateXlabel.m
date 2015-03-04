function h_out = updateXlabel(h, varargin)
%{
    eg first time, call:
        h_xlabel = updateTitle([], 'labelname1')
    next time (to update), call:
        h_xlabel = updateText(h_xlabel, 'labelname2', 'color', 'g')
%}
    syntaxPossibilities = {{'char'}, {'String'}};

    h_out_tmp = updateHGFunction(@xlabel, h, syntaxPossibilities, varargin{:});
    if nargout > 0
        h_out = h_out_tmp;
    end        

end