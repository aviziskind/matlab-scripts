function [uVal, valCount] = uniqueIntCount_no_sort(x)
%     n = length(x);
    x_min = min(x);
%     x_max = max(x);
    D = (x_min-1);
    x_bin = x - D;
%     nBins = x_max - D;
   
    [uBinIds, valCount] = uniqueBinCount(x_bin);
    uVal = uBinIds + D;
    

end