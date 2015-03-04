function X = countIdxs_Matlab(dims, idx)
    X = zeros(dims);
    for i = 1:numel(idx)
        X(idx(i)) = X(idx(i))+1;
    end
end
