function [x_wrap, y_wrap] = wrap_xy(x, y, N, addNanForPlotting_flag)
    %%
    x_wrap = mod1(x(:), N);
    y_wrap = y(:);
    idx_circ = find(diff(x_wrap) < -N/2);
    
    addNanForPlotting = nargin >= 4 && isequal(addNanForPlotting_flag, 1);
    if ~isempty(idx_circ) && addNanForPlotting
        x_wrap = [x_wrap(1:idx_circ); nan; x_wrap(idx_circ+1:end)];
        y_wrap = [y_wrap(1:idx_circ); nan; y_wrap(idx_circ+1:end)];
    end
    
    
end