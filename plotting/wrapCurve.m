function [x_wrap, y_wrap] = wrapCurve(x,y,wrapPoint, wrapTo)
    x = x(:)';
    y = y(:)';
    if nargin < 4
        wrapTo = 0;
    end

    idx_keep = x <= wrapPoint;
    idx_wrapAround = x > wrapPoint;
    
    x_wrap = [x(idx_keep), nan, x(idx_wrapAround)-wrapPoint+wrapTo];
    y_wrap = [y(idx_keep), nan, y(idx_wrapAround)];
    
end