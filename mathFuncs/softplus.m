function y = softplus(x, minValue, scl)
    if nargin < 2
        minValue = 0;
    end
    if nargin < 3
        scl = 1;
    end

    
%     y = (log(1 + exp(  (x - minValue)*scl ) ))/scl + minValue;
    
    x_scaledOffset = (x - minValue)*scl;

    y_scaledOffset = (log(1 + exp(  x_scaledOffset ) ));
    
    y = y_scaledOffset/scl + minValue;

    idx_inf = isinf(y);
    if any(idx_inf)
        3;
    end
    y(idx_inf) = x(idx_inf);

end