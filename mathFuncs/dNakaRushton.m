function ds = dNakaRushton(x, M, c, n)
    if nargin < 4
        n = 1;
    end
    if x <= 0
        ds = 0;
        return;
    end
    xn = x.^n;
    xn1 = x.^(n-1);
    cn = c.^n;
    ds = (M .* n .* xn1.* cn)./((xn+cn).^2);
    
end