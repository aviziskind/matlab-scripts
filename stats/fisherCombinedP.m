function p = fisherCombinedP(pvals)
    k = length(pvals);
    X2 = -2* sum( log (pvals));
    
    p = 1-chi2cdf(X2, 2*k);    
end