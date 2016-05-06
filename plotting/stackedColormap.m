function [gradedColors] = stackedColormap(baseColors, nLevelsTot, minLevel, maxLevel)
    if nargin < 1
        baseColors = 4;
    end
    if isscalar(baseColors)
%         baseColors = prism(baseColors);
%                             r      g       b       cy         mag         yel          gry          bluish   
%         origLines_full = [0 0 1; 0 .5 0; 1 0 0; 0 .75 .75; .75 0 .75; .75, .75, 0; .25 .25 .25;0 0.447 0.741 ];
% 
%         head: 0 0 1;   [r]
%         Lsh  0 .5 0    [g]  
%         rSh  1 0 0     [b]
%         
%         Ch    .25 .25 .25 ;  [gray]
%         Rel   0, 0.75, 0.75  [cyan] 
%         Lel   0.466 0.674 0.188 [greenish]
%         Rh   0.75 0 0.75  [mag]
%         Lh   0.75 0.75 0 [yellow]

        origLines_full = [0 0 1; 0 .5 0; 1 0 0; 0.25 0.25 0.25;    0, 0.75 0.75;  0.466 0.674 0.188;  0.75 0 0.75; 0.75 0.75 0]; %  0 .75 .75; .75 0 .75; .75, .75, 0; .25 .25 .25;0 0.447 0.741 ];
        
%         origLines_full = [0 0 1; 0 .5 0; 1 0 0; 0 .75 .75; .75 0 .75; .75, .75, 0; .25 .25 .25;0 0.447 0.741 ];
        
%       origLines_full = [0 0.447 0.741; 0.850 0.325 0.098; 0.929 0.694 0.125; 0.494 0.184 0.556; 0.466 0.674 0.188; 0.301 0.745 0.933; 0.635 0.078 0.184];
        
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
    
    if nargout == 0
        colormap(gradedColors);
    end
        
end