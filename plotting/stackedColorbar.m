function stackedColorbar(colorbar_ticks_C, nToShowTotal)
%%
    nColors = length(colorbar_ticks_C);
    nLevelsEach = length(colorbar_ticks_C{1});
    
    if nargin < 2
        nToShowTotal = 12;
    end
    nToShowEach = ceil(nToShowTotal / nColors);

    idx_use = round(linspace(1, nLevelsEach, nToShowEach*2+1));
    idx_use = idx_use(2:2:end);
    %%
    
    h = colorbar;
    colorbar_ticks_use_C = cellfun(@(idxs) idxs(idx_use), colorbar_ticks_C, 'un', 0);
    idxs_ticks_use_global_C = cellfun(@(i) idx_use + (i-1) * nLevelsEach, num2cell(1:nColors), 'un', 0);
    idxs_ticks_use_global = [idxs_ticks_use_global_C{:}];
    colorbar_ticks_use = [colorbar_ticks_use_C{:}];
    
    ticks_str = arrayfun(@(x) sprintf('%.2f', x), colorbar_ticks_use, 'un', 0);

    set(h, 'ytick', idxs_ticks_use_global, 'yticklabel', ticks_str);
        
    

    


end