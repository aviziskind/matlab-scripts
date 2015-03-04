function [gradedColors, cmapSclFactor_indiv, cmapSclFactor_group] = getStackedCmap(baseColors, addBlackFlag)
        
    if exist('addBlackFlag', 'var') && ~isempty(addBlackFlag);
        nAdd = 1; % add one layer of 'black' at the bottom of the colormap.
    else
        nAdd = 0;
    end        
    nCols = size(baseColors, 1);
    
    nScl = floor((255-nAdd)/nCols);    

    idx_black = find(~any(baseColors,2));
    if ~isempty(idx_black)
        baseColors(idx_black, :) = .5; % replace with grey (so that can scale).
    end
    
    gradedColors_C = cellfun(@(clr) linspace(.5, 1.3,nScl)' * clr, mat2cell(baseColors, ones(1,nCols), 3), 'un', 0);
    gradedColors_C = cellfun(@(x) x/max(x(:)), gradedColors_C, 'un', 0);
    gradedColors = [cat(1, zeros(nAdd,3), gradedColors_C{:})];
    gradedColors = double( min(gradedColors,1) );
    
    cmapSclFactor_indiv = 1 + (nAdd+1)/nScl;
    cmapSclFactor_group = (nAdd)/(nScl*(nCols)+nAdd);                               
    
end