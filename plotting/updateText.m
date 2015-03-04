function h_out = updateText(h, varargin)
%{
    eg first time, call:
        h_txt = updateText([], x,y, 'Hello', 'fontsize', 3)
    next time (to update), call:
        h_txt = updateText(h_txt, x2, y2, 'Hello 2', 'fontsize', 6)
%}

    syntaxPossibilities = {{'numeric', 'numeric', 'char'},               @(x,y,str) {'Position', [x y 0], 'String', str};   % ie. text(x,y,'String')
                           {'numeric', 'numeric', 'cellstr'},            @(x,y,cstr) {'Position', [x y 0], 'String', cstr}; % ie. text(x,y,z,'String')                       
                           {'numeric', 'numeric', 'numeric', 'char'},    @(x,y,z,str) {'Position', [x y z], 'String', str}; % ie. text(x,y,z,'String')
                           {'numeric', 'numeric', 'numeric', 'cellstr'}, @(x,y,z,cstr) {'Position', [x y z], 'String', cstr} }; % ie. text(x,y,z,'String')
                              
    h_out_tmp = updateHGFunction(@text, h, syntaxPossibilities, varargin{:});
    if nargout > 0
        h_out = h_out_tmp;
    end        
    
    
end