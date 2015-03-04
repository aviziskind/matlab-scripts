function hout = histcplot_color(x, x_groups, xedges)
    ind_nonnans = (~isnan(x) & ~isnan(x_groups));
    if nnz(ind_nonnans) == 0
        ind_nonnans = ~isnan(x);  % if all x_groups's are nans
        x_groups = [];
    end
    if (length(ind_nonnans) < length(x)) % remove nans from data (if any)
        x = x(ind_nonnans);    
        x_groups = x_groups(ind_nonnans);
    end
    
    uCategories = unique(x_groups);
    nCat = length(uCategories);    

    if length(x) == length(x_groups)
        binvals = zeros(length(xedges)-1, nCat);

        for c = 1:nCat
            idx_xsInThisInterval = (x_groups == uCategories(c));
            n = histc(x(idx_xsInThisInterval), xedges);
            n(end-1) = n(end-1) + n(end);   n(end) = [];   % put last bin value into prev bin.    
            binvals(:,c) = n;
        end
        
    elseif isempty(x_groups)
        n = histc(x, xedges);
        n(end-1) = n(end-1) + n(end);   n(end) = [];   % put last bin value into prev bin.    
        binvals = n;
        
    else
        error('Number of valid elements in x and x_groups must be the same');
    end
        
    xcent = xedges(1:end-1) + diff(xedges)/2;     
    h = bar(xcent, binvals, 1, 'barlayout', 'stacked');
    if nargout == 1
        hout = h;
    end    
    
end