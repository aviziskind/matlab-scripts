function adjustStackedBarHeights(h, N)
    % algorithm to quickly adjust the heights of bars in a stacked bar
    % graph. 
    % the original call would have been made using something like
    %   h = bar(N, 'stacked')
    % call this function with the returned handle 'h', together with a new
    % matrix of bar values N, of the same dimension as the original N.
    %
    % Each column of N(:,i) will correspond to the new y values in the
    % barseries h(i).
    [nbars, nseries] = size(N);
    cumN = [zeros(nbars, 1), cumsum(N, 2)];
    
    for si = 1:nseries
        h_patch = get(h(si), 'children');
        patch_v = get(h_patch, 'vertices');
        for bi = 1:nbars
            inds = 5*bi + [-3, -2, -1, -0];
            lo = cumN(bi, si);
            hi = cumN(bi, si+1);
            newvals = [lo, hi, hi, lo];
            patch_v(inds, 2) = newvals;            
        end
        set(h_patch, 'vertices', patch_v);
    end
    
end
