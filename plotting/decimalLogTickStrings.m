function [tickVals_str, tickVals] = decimalLogTickStrings(loglims)
        
    loglim_lo = floor( log10(loglims(1)) );
    loglim_hi = ceil( log10(loglims(2)) );
    
    %%
    log_tickVals = loglim_lo : loglim_hi;  %log10(loglims(1)) : log10(loglims(2));
    tickVals = 10.^log_tickVals;
    
    tickVals = tickVals(ibetween(tickVals, loglims))
    
    nTicks = length(tickVals);

    tickVals_str = cell(1,nTicks);
    for i = 1:nTicks;
        logTickVal = log10(tickVals(i));
        if logTickVal >= 0

            tickVals_str{i} = sprintf('%d', tickVals(i));
        else
            tickVals_str{i} = sprintf(['%.' num2str(abs(logTickVal)) 'f'], tickVals(i));
        end
    end

end


