function [uBinIds, binCount] = uniqueBinCount(binIds)
    n = length(binIds);
    maxBinId = max(binIds);
    
    uBinIds = 1:maxBinId;
    binCount = zeros(1, maxBinId);
    for i = 1:n
        binCount(binIds(i)) = binCount(binIds(i))+1;
    end
    
end
