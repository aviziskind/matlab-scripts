function tf = ibetween(x, a, b)
    if nargin == 2
        if isvector(a)
            a = a(:)';
        end
        b = a(:,2);
        a = a(:,1);
    end
    3;
    tf = ((a <= x) & (x <= b));
end