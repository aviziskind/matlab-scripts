function ux = uniqueInOrder(x)
    [ux, m] = unique(x, 'first');
    [~, orig_idx] = sort( m );
    ux = ux(orig_idx);
end
