function xr = rescale(x, rangeA, rangeB)
    xr = ( (x - rangeA(1)) / diff(rangeA([1,end])) ) * diff(rangeB([1,end])) + rangeB(1);
end

