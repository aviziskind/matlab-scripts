function hout = histcplot_pval(x, px, xedges, sets)
    inds = (~isnan(x) & ~isnan(px));
    if nnz(inds) == 0
        inds = ~isnan(x);  % if all px's are nans
        px = [];
    else
        x = x(inds);    
        px = px(inds);
    end
    if ~exist('sets', 'var') %|| isempty(sets)
        sets = [0, .01, .05, .1, 1];
    end
    assert( all(ibetween(px, sets(1), sets(end)) ));
    sets = sort(sets);
%     if (sets(1) ~= 0),   sets = [0, sets]; end;
%     if (sets(end) ~= 1), sets = [sets, 1]; end;
    pIntervals = length(sets) - 1;

    if length(x) == length(px)
        binvals = zeros(length(xedges)-1, pIntervals);

        for i = 1:pIntervals
            if (i == 1)  % include (p == 0) in first set.
                idx_xsInThisInterval = (sets(i) <= px) & (px <  sets(i+1));
            elseif (i > 1)
                idx_xsInThisInterval = (sets(i) <= px) & (px <= sets(i+1));
            end
            
            n = histc(x(idx_xsInThisInterval), xedges);
            n(end-1) = n(end-1) + n(end);   n(end) = [];   % put last bin value into prev bin.    
            binvals(:,i) = n;
        end
        
    elseif isempty(px)
        n = histc(x, xedges);
        n(end-1) = n(end-1) + n(end);   n(end) = [];   % put last bin value into prev bin.    
        binvals = n;
        
    else
        error('Number of valid elements in x and px must be the same');
    end
        
    xcent = xedges(1:end-1) + diff(xedges)/2;     
    h = bar(xcent, binvals, 1, 'barlayout', 'stacked');
    if nargout == 1
        hout = h;
    end    
    
end