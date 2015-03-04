function h = entropy(x)
    h = zeros(size(x));
    idx_nz = find(x > 0);    
    h(idx_nz) = -x(idx_nz).*log2(x(idx_nz));    
end
