function [gradedColors] = stackedColormap(baseColors, nLevelsTot, minLevel, maxLevel)
    if nargin < 1
        baseColors = 4;
    end
    if isscalar(baseColors)
%         baseColors = prism(baseColors);
        origLines_full = [0 0 1; 0 .5 0; 1 0 0; 0 .75 .75; .75 0 .75; .75, .75, 0; .25 .25 .25];
        baseColors = origLines_full(1:baseColors, :);
        
        if size(baseColors,1) >= 3
            baseColors([1,3],:) = baseColors([3,1],:);
        end
    end
    
    nColors = size(baseColors,1);
    addBlackAtBottom = true;
    
    if nargin < 2 
        nLevelsTot = 255;
    end
    nLevelsEachColor = floor((nLevelsTot-addBlackAtBottom) / nColors);        
    
    if nargin < 3
%         minLevel = 0.4;
        minLevel = 0;
    end
    if nargin < 4
%         maxLevel = 1.3;
        maxLevel = 1;
    end
    
    idx_black = find(~any(baseColors,2));
    if ~isempty(idx_black)
        baseColors(idx_black, :) = .5 * [1,1,1]; % replace with grey (so that can scale).
    end
    
    baseColors_C = mat2cell(baseColors, ones(1,nColors), 3);
    gradedColors_C = cellfun(@(clr) linspace(minLevel, maxLevel,nLevelsEachColor)' * clr, baseColors_C, 'un', 0);
    gradedColors_C = cellfun(@(x) x/max(x(:)), gradedColors_C, 'un', 0);
    gradedColors = cat(1, gradedColors_C{:});
    if addBlackAtBottom
        gradedColors = [zeros(1,3); gradedColors];
    end
    gradedColors = double( min(gradedColors,1) );
        
end