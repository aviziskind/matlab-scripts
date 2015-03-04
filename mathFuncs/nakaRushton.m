function s = nakaRushton(x, M, c, n)
    if nargin < 4
        n = 1;
    end
    if x <= 0
        s = zeros(size(x));
        return;
    end
    xn = x.^n;
    cn = c.^n;
    s = M .* (xn)./(xn+cn);
end