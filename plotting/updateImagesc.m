function h_out = updateImagesc(h, varargin)
%     h_out = updateText(h, everyTimeArgs)
%     h_out = updateText(h, {everyTimeArgs})
%     h_out = updateText(h, {everyTimeArgs}, {firstTimeArgs})

    h_out_tmp = updatePlotFunction(@imagesc, h, varargin{:});
    if nargout > 0
        h_out = h_out_tmp;
    end        
end