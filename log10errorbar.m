function log10errorbar(X, Y, E, style)
if (nargin < 4)
        errorbar(X, log10(Y), log10(Y)-log10(Y-E), log10(Y+E)-log10(Y), '.');
    else
        errorbar(X, log10(Y), log10(Y)-log10(Y-E), log10(Y+E)-log10(Y), style);
    end
    
    xlog = strcmp(get(gca, 'xscale'), 'log');
    ylog = strcmp(get(gca, 'yscale'), 'log');
    
    
    
    
end
