function plotyequalsx
    hold_state = ishold;    
    hold on
    
    fplot(@(x) x, xlim, 'k:')
    
    if ~hold_state, hold off; end    
end