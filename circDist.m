function d = circDist(x1,x2,x_max)
    % calculate circular distance (eg around a circle of 360 degrees).
    if nargin < 3
        x_max = 360;
    end
    d = mod(x2-x1, x_max);
    d = min(d, x_max-d);
        
end