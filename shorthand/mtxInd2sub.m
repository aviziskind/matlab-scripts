function subs = mtxInd2sub(inds, n)
    subs = [mod(inds(:)-1,n)+1 , ceil(double(inds(:))/n);];  % make sure is double, not integer type - otherwise truncates after division.
end 