function [lims_best, nticks_best] = bestLimsFromData(x, n)
    % input a number 'n', between 1 and 9.  
    %   ( 1 --> tight margins. 9 --> generous margins )

    xmin = min(x);
    xmax = max(x);
    
    if nargin < 2
        n = 3;
    end

    % function [low,high,ticks] = goodscales(xmin,xmax)
    %GOODSCALES Returns parameters for "good" scales.
    %
    % [LOW,HIGH,TICKS] = GOODSCALES(XMIN,XMAX) returns lower and upper
    % axis limits (LOW and HIGH) that span the interval (XMIN,XMAX)
    % with "nice" tick spacing.  The number of major axis ticks is
    % also returned in TICKS.
    % copied from 'plotyy' function

    BestDelta = [ .1 .2 .5 1 2 5 10 20 50 ];
    
    if xmin==xmax, 
        lo=xmin; hi=xmax+1; nticks_best = 1;         
    else        
        Xdelta = xmax-xmin;
        delta = 10.^(round(log10(Xdelta)-1))*BestDelta;
        high = delta.*ceil(xmax./delta);
        low = delta.*floor(xmin./delta);
        nticks = round((high-low)./delta)+1;

        hi = high(n);
        lo = low(n);        
        nticks_best = nticks(n);
    end
    
    lims_best = [lo, hi];
end




%{ 
my old algorithm (couldn't handle negative data)

    b = 10;  % base (usually 10)
    if nargin < 2
        n = 15; % how closely the maxes are to the limits of the data.
    end

    L = min(x);
    U = max(x);
    allSame = U==L;
    d = iff(allSame, U/10, U-L);
    sig = b .^ floor( log(d/n)/log(b) );
    
    % find lower limit
    down = mod(L, sig);
    L = L - down;
    
    % find upper limit
    up = mod(U, sig);
    if (up ~= 0) 
        U = U + (sig - up);
    end

    if (U == L)  % get error if do xlim([x x]);
        U = U + 1;
    end
    lims = [L, U];

%}