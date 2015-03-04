function i = indmax_n(x, n)
    if n == 1
        i = indmax(x);
    else
        [~, idx] = sort(x, 'descend');
        i = idx(1:n);
    end
end
