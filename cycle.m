function nextX = cycle(X, vals, howMuch)
    if nargin < 3
        howMuch = 1;
    end
    idx = find(X == vals) + howMuch;
    if idx > length(vals)
        idx = 1;
    end
    if idx < 1
        idx = length(vals);
    end
    nextX = vals(idx);
end