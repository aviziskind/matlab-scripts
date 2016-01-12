function H = stepFunction(X, s);
    if nargin < 2
        s = 0;
    end

    H = double(X > s);
end