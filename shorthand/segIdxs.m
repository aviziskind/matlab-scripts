function idxs = segIdxs(nTot, nGroups)
    nPerGroup = (nTot/nGroups);
    if nPerGroup == round(nPerGroup)
        idxs = arrayfun(@(i) [1:nPerGroup]+nPerGroup*(i-1), 1:nGroups, 'un', 0);
    else
        %%
%         all_idxs = 1:nTot;
        for j = 1:nGroups
            group_idx = floor(([1:nTot]-1)/nPerGroup)+1;
            [u, idxs] = uniqueList(group_idx);
            assert(isequal(u, 1:nGroups));
            assert(isequal(vertcat(idxs{:})', 1:nTot));
            assert( all( ibetween( cellfun(@length, idxs), floor(nPerGroup), ceil(nPerGroup) ) ) ); 
        end
        
    end
    

end