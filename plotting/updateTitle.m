function h_out = updateTitle(h, varargin)
%{
    eg first time, call:
        h_title = updateTitle([], 'Title 1')
    next time (to update), call:
        h_title = updateText(h_title, 'Title 2')
%}
    syntaxPossibilities = {{'char'}, {'String'};
                           {'cellstr'}, {'String'}};

    h_out_tmp = updateHGFunction(@title, h, syntaxPossibilities, varargin{:});
    if nargout > 0
        h_out = h_out_tmp;
    end        

end