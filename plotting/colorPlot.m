function h_out = colorPlot(h, X, c, nColors, varargin)
%     nColors = 30;
    % h_out = colorPlot(h, {x, y}, c)
    % h_out = colorPlot(h, {x, y}, c, nColors)
    % h_out = colorPlot(h, {x, y}, c, {nColors, cmap}, 'linestyle)

    error(nargchk(3,inf, nargin));
    if nargin < 4
        nColors = 30;
    end
    
    if iscell(nColors)
        if length(nColors) == 3
            [nCol, cmap, clims] = deal(nColors{:});
            if length(clims) == 2
                clims = linspace(clims(1), clims(2), nCol);
            end
        elseif length(nColors) == 2
            [nCol, cmap] = deal(nColors{:});
        end
        nColors = nCol;
    else
        cmap = @jet;
    end
    
    if ~iscell(X)
        error('arg 2 must be a cell array of co-ordinates {x, y} or {x,y,z}');
    end
    nDim = length(X);
    x = X{1}; y = X{2}; 
    if length(x) ~= length(y)
        error('X and Y must be of the same length');
    end
    if nDim == 2
        plotN = @plot;        
    elseif nDim == 3
        plotN = @plot3;
        z = X{3};
    else
        error('arg 2 must have either 2 or 3 co-ordinates');
    end
        
    
    firstTime = isempty(h) || any(h == 0) || any(~ishandle(h)) || length(h) ~= nColors;
    
    if firstTime
        colr_map = cmap(nColors);                
        h = zeros(1,nColors);
        
%         noLineArgs = iff(nDim == 2, {'linestyle', 'none'}, {});
        noLineArgs = {'linestyle', 'none'};
        hold_state = ishold;
        tmpCoords = repmat({1},1,nDim);    
        for color_i = 1:nColors
            h(color_i) = plotN(tmpCoords{:}, varargin{:}, 'color', colr_map(color_i,:), noLineArgs{:});
            if color_i == 1, hold on, end;
        end
        if ~hold_state, hold off, end;    
        set(h(color_i), 'xdata', [], 'ydata', []);
    end
    
    if ~exist('clims', 'var')
        clims = linspace(min(c)-eps, max(c)+eps, nColors+1);
    end
    
    if ~isempty(c)
        [tmp, data_c] = histcnt(c, clims);
    else 
        data_c = [];
    end
            
    for color_i = 1:nColors
        idx = (data_c == color_i);
        set(h(color_i), 'xdata', x(idx), 'ydata', y(idx));
        if nDim == 3
            set(h(color_i), 'zdata', z(idx));
        end
    end
    
    if nargout > 0
        h_out = h;
    end        
    
end