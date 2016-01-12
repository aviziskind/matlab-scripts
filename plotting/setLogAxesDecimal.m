function setLogAxesDecimal(whichAx, h_ax, loglims)

    if nargin < 2 || isempty(h_ax)
        h_ax = gca;
    end

    if nargin < 1 || isempty(whichAx)
        if strcmp(get(h_ax, 'xscale'), 'log')
            setLogAxesDecimal('x');
        end
        if strcmp(get(h_ax, 'yscale'), 'log')
            setLogAxesDecimal('y');
        end
        return;
    end

    switch lower(whichAx), 
        case 'x',
            tick_name = 'xtick';
            tickLabel_name = 'xticklabel';
            lim_name = 'xlim';
        case 'y',
            tick_name = 'ytick';
            tickLabel_name = 'yticklabel';
            lim_name = 'ylim';

    end
    
    
    if nargin < 3 || isempty(loglims)
        loglims = get(h_ax, lim_name);
    end

    [tickVals_str, tickVals] = decimalLogTickStrings(loglims);
    
    set(h_ax, tick_name, tickVals, tickLabel_name, tickVals_str);
        
end


