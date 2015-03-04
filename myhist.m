function [x, y, s] = myhist(data, numbins_plot)
% function [x, y, s] = myhist(data, numbins)

    doplot = false;

    lbound = min(data);
    ubound = max(data);
    if (nargin == 2)
        if isa(numbins_plot, 'char')
            binsize = 1;
            doplot = true;
        else
            binsize = (ubound-lbound)/(numbins);
        end
    else
        binsize = 1;
    end
    x = lbound+binsize/2:binsize:ubound-binsize/2;

    %align data nicely into bins
    offsets = mod(data,binsize);
    discretized = data - offsets + binsize/2;

    %prevent overflow of outermost bins
    eps = 0.0001;
    discretized = discretized - (discretized + eps >= ubound)*binsize;
    discretized = discretized + (discretized - eps <= lbound)*binsize;
    
    %put data into bins
    binned = zeros( length(x),1);
    xtoi = @(x) ((x-binsize/2 - lbound)/binsize)+1;
    for i = 1:length(discretized)
        index = int16(xtoi( discretized(i) ));
        binned(index) = binned(index) + 1;
    end
    s = binsize;
    y = binned;

    if doplot
        bar(x,y, 0.9);
    end
end