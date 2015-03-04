function ctrl_dist = ks_getCtrlDist(X, pairs_ok)
    if ~iscell(X)
        assert(nargin < 2); % can't select pairs for Bcc or if don't have cell array.
        
        X = X(~isnan(X));
        allValsX = X(:);
        uValsX = unique(allValsX);        
                
    else
        %%
        assert(size(X,2) == 2);        
        have_values = ~cellfun(@isempty, X(:,1));  % empty ones are where have nans
        if nargin == 2
            idx_use = have_values & pairs_ok;
        else
            idx_use = have_values;
        end
        
        if ~any(idx_use)
            ctrl_dist = [];
            return;
        end
        
        nRep_C = X(idx_use,1);
        vals_C = X(idx_use,2);
                
        uValsX = unique([vals_C{:}])';
        
        allValsX_C = cellfun(@(rep, vals) repmat(vals(:)', 1, rep), nRep_C, vals_C, 'un', 0);
        allValsX = [allValsX_C{:}];        
        
    end
        %%
    binEdges = [-inf ; uValsX(:); inf];    
    binCounts  =  histc (allValsX(:), binEdges(:) );
    sumCounts  =  cumsum(binCounts)./sum(binCounts);            
    
    CDF  =  sumCounts(1:end-1);    
    ctrl_dist = struct('binEdges', double(binEdges), 'CDF', double(CDF));
end
