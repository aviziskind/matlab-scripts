function rescaleSubplots(hs, ps, dependentHs)
    if length(hs) ~= length(ps)
        error('Handles and proportions vectors must be the same lenght');
    end

    addPaddingAtBottom = true;
    offset = 0;
    
    ps = ps/sum(ps);  %normalize
    if addPaddingAtBottom
        paddingWidth = .09;
        ps = [ps(:); paddingWidth];
        ps = ps/sum(ps);  %normalize
        offset = 1;
    end
    ps = flipud( ps(:) ); % flip, b/c intuitively we want to do top/down, but the design 
    hs = flipud( hs(:) ); % of the variables makes it more natural to specify from bottom/up    
    if nargin > 2
        dependentHs = flipud(dependentHs(:));
    end
    set(hs, 'ActivePositionProperty', 'Outerposition', 'Units', 'normalized');
    
    for i = 1:length(hs)
        if (ps(i+offset) == 0)
            set(hs(i), 'Visible', 'off');
        else
            P = [0, sum(ps(1:i-1+offset)), 1, ps(i+offset)];
            if exist('dependentHs', 'var') && iscell(dependentHs) && (length(dependentHs) >= i) && ~isempty(dependentHs{i})
                set(dependentHs{i}, 'ActivePositionProperty', 'Outerposition', 'Outerposition', P);
            end
                set(hs(i), 'Visible', 'on', 'OuterPosition', P);
        end        
    end


end
