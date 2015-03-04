function element_no = element(x, n)
    if iscell(x)
        element_no = x{n};
    else
        element_no = x(n);
    end
end