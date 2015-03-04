function m = nangeomean(x)
    
    m = geomean(x(~isnan(x)));

end