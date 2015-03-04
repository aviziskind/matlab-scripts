function [uBinIds, binIdxLists] = uniqueBinList(binIds)
    n = length(binIds);
    maxBinId = max(binIds);
    
    uBinIds = 1:maxBinId;
    binCount = zeros(1, maxBinId);
    for i = 1:n
        binCount(binIds(i)) = binCount(binIds(i))+1;
    end
    %%
    binIdxLists = arrayfun(@(m) zeros(1,m), binCount, 'un', 0);
    assert(isequal(cellfun(@length, binIdxLists), binCount));
    binIdx = ones(1, maxBinId);
    
    for i = 1:n
        bId = binIds(i);
        binIdxLists{bId}(binIdx(bId)) = i;
        binIdx(bId) = binIdx(bId) + 1;
    end
    assert(isequal(cellfun(@length, binIdxLists), binCount));
    
    idx_keep = binCount > 0;    
    uBinIds = uBinIds(idx_keep);
    binIdxLists = binIdxLists(idx_keep);
    
%     [uBinIds2, binIdxLists2] = uniqueList(binIds);
%     assert(isequal(uBinIds, uBinIds2));
%     assert(isequal(binIdxLists, binIdxLists2));

    3;
end
