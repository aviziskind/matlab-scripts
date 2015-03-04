function varargout = histcnt(vals, edges, wgts, discardLastBinFlag)
    nargoutchk(0,2) ;
    narginchk(2,4) ;
    getBinIds = (nargout > 1) || ((nargin == 3) && ~isempty(wgts));
    if getBinIds
        [n, bin] = histc(vals, edges);   
    else
        n = histc(vals, edges);            
    end
    
    discardLastBin = exist('discardLastBinFlag', 'var') && ~isempty(discardLastBinFlag) && discardLastBinFlag;
    
    if isempty(n)
        n = zeros(1,length(edges)); % will discard the last bin later (line #26)
    end
    
    % last bin contains all elements equal to edges(end)
    % we can either put all these elements into the second last bin
    % (default), or we can just discard them (if a non-empty 4th 'flag' argument
    % is provided).
    % Thus, length of n becomes (length(edges)-1) instead of (length(edges)) 
    idx_end = length(edges);
    
    if ~discardLastBin          
        assert(length(n) == idx_end);
        n(idx_end-1) = n(idx_end-1) + n(idx_end);    % put last bin value into prev bin.
        if getBinIds
            bin(bin == idx_end) = idx_end-1;            
        end        
    end
    n(idx_end) = [];                             

    if exist('wgts', 'var') && ~isempty(wgts)
        % we will recalculate n as a weighted sum instead of a simple
        % counting.
        %%
        N = length(n);
%         n = zeros(1,N);        
%         [uBinIds, binLists] = uniqueList(bin);
%         idx0 = find(uBinIds==0,1);
%         if ~isempty(idx0)
%             uBinIds(idx0) = [];
%             binLists(idx0) = [];
%         end
%         for i = 1:length(uBinIds)
%             n(uBinIds(i)) = sum( wgts( binLists{i} ) );
%         end        
        n = weightedBinCounts(bin, wgts, N);
%         assert(isequal(n_wgt, n));
    end

                                     
    if nargout <= 1
        varargout = {n}; 
    else
        ind_lastbin = bin == length(edges);
        bin(ind_lastbin) = length(edges)-1;
        varargout = {n, bin};
    end
               
end


