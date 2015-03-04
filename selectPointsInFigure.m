function selectPointsInFigure(src, evnt, clickFunction) %#ok<INUSL>
%{
 General-purpose function to select points in a figure.
 Assign this function as one of the callback's of a figure window,
 (eg. to have this function called whenever you click on figure 5 :
 set (        
    set(5, 'windowButtonDownFcn', @selectPointsInFigure);

 Then, every time you click on the figure, the cursor will change to a 
 cross-hair cursor and you will be allowed to zoom in (right 
 click) or zoom out (shift-right click), until you select a point
 select a point (left click). 

 If you want to run a specific function, say, "clickFunction", after a 
 particular point is selected, pass a handle to it as an argument, 
 by putting it in a cell array with the handle to this function, as follows:

    set(5, 'windowButtonDownFcn', {@selectPointsInFigure, @clickFunction});

 The clickFunction must define the following 5 inputs

    clickFunction(glob_id, grp_id, loc_id, x, y) %#ok<INUSL>

%}
    showCurPoint = true;

    cur_fig = gcf;
    cur_ax = gca;
    maxZoomLevel = 15;
    zoom_factor = 2;
    
%     markerSize = 6;
%     markerShape = '*'; 
%     markerColor = 'k';
    
    showZoomLevelInFigureTitle = true;
    resetAxesWhenZoomingOut = true;
    zoomOutAfterSelection = false;
        slowZoomOut = true;
    printSelectedInfoIfNoFunction = false;
    onlySelectVisibleData = true;    

    gotFunction = exist('clickFunction', 'var') && ~isempty(clickFunction);    

    if ~gotFunction && printSelectedInfoIfNoFunction
        clickFunction = @printSelected;
        gotFunction = true;        
    end
            
        
    userData = get(cur_fig, 'userData');
    
    if isempty(userData)
        hCurPoint = [];
        curZoomLevel = 1;
        xlims0 = get(cur_ax, 'xlim');
        ylims0 = get(cur_ax, 'ylim');
        userData = {hCurPoint, xlims0, ylims0, curZoomLevel};
        set(cur_fig, 'userData', userData);        
    else        
        [hCurPoint, xlims0, ylims0, curZoomLevel] = userData{:};        
    end
    xlims = xlim;
    ylims = ylim;
%     if any(isinf(xlims)) % handle the case where one of the limits is set to 'inf' (ie. automatic limits)
%         get(cur_ax, 'xlims0
%         
%     end
        
    xLogScale = strcmp(get(gca, 'xscale'), 'log');   
    yLogScale = strcmp(get(gca, 'yscale'), 'log');
    
    ax_children = get(cur_ax, 'children');        
    ax_children = setdiff(ax_children, hCurPoint);    
    if onlySelectVisibleData
        isVisible = strcmp('on', get(ax_children, 'visible'));
        ax_children = ax_children(isVisible);
    end
    
    % remove children which are specifically marked to be skipped    
    idx_toSkip = strcmpi(get(ax_children, 'userdata'), 'skipSelect') ;
    ax_children(idx_toSkip) = [];
    
    % pick out plots which are have x and y data ('lines', 'scatter', etc)
    idx_WithPoints = isprop(ax_children, 'xdata')  ;            
    hLines = ax_children(idx_WithPoints);

%     idx_WithPoints = find( strcmp(get(ax_children, 'type'), 'line') ) ;            
    
    if isempty(hLines)
        return;
    end
    
    nCh = length(hLines);
    
    if nCh > 1
        
        all_x = get(hLines, 'xdata');
        all_y = get(hLines, 'ydata');
        nChPoints = cellfun(@length, all_x);        
        X = [all_x{:}];
        Y = [all_y{:}];
        Group_Ids  = arrayfun( @(n) ones(1,nChPoints(n)) * n,                 1:nCh, 'un', 0);     Group_Ids = [Group_Ids{:}];
%         cum_nChPoints = [0; cumsum( nChPoints )];
%         offsets    = arrayfun( @(n) ones(1,nChPoints(n)) * cum_nChPoints(n) , 1:nCh, 'un', 0);       offsets = [offsets{:}];
        Local_Ids    = arrayfun( @(n) 1:nChPoints(n), 1:nCh, 'un', 0);       Local_Ids = [Local_Ids{:}];

    elseif nCh == 1        
        X = get(hLines, 'xdata');
        Y = get(hLines, 'ydata');
        Group_Ids = ones(1, length(X));
        Local_Ids = 1:length(X);
    
    elseif nCh == 0
        return
    end
%     npoints = length(X);

    
    done = false;
    while ~done
    
        [cur_x,cur_y, button] = ginput(1);
        
        if ~ibetween(cur_x, xlims) && ibetween(cur_y, ylims) 
            done = true;
        else
%         fprintf('%d\n', button);
%             sType = get(cur_fig, 'selectionType');            fprintf(sType);

            switch button
                case 1  % find closest data point
                    axes_aspectratio = axaspect;
%                     da = da(2)/da(1);
                    [X2, Y2, cur_x2, cur_y2] = deal(X, Y, cur_x, cur_y);
                    if xLogScale
                        xScaleFunc = @log10;
                    else
                        xScaleFunc = @(x) x;
                    end                    
                    X2 = xScaleFunc(X2); 
                    cur_x2 = xScaleFunc(cur_x2);
                    r_x = diff(xScaleFunc(xlims)) * axes_aspectratio ;
                        
                    if yLogScale
                        yScaleFunc = @log10;
                    else
                        yScaleFunc = @(x) x;
                    end
                    Y2 = yScaleFunc(Y2); 
                    cur_y2 = yScaleFunc(cur_y2);
                    r_y = diff(yScaleFunc(ylims));
                    
                    diff_x = (X2(:)-cur_x2)/r_x;
                    diff_y = (Y2(:)-cur_y2)/r_y;
                    
%                     hold on;
%                     plot(cur_x, cur_y, 'r.');                    
                    dists = normV([diff_x(:), diff_y(:)], 2);
                    idx_closest = indmin( dists );

                    if isempty(hCurPoint) || ~ishandle(hCurPoint)
                        hold_state = ishold;
                        hold on;
                        hCurPoint = plot(X(idx_closest), Y(idx_closest));
                        if ~hold_state, hold off; end

                        userData{1} = hCurPoint;
                        set(cur_fig, 'userData', userData);                    
                    else
%                         set(hCurPoint, 'xdata', [cur_x, X(idx_closest)], 'ydata', [cur_y, Y(idx_closest)]);                                                                
                        set(hCurPoint, 'xdata', X(idx_closest), 'ydata', Y(idx_closest));
                    end                    
                    if ~showCurPoint
                        set(hCurPoint, 'visible','off');
                    else
                        set(hCurPoint, 'visible','on');
                    end

    %                 fprintf('%d [%d:%d], (%.2f, %.2f)\n', idx_closest, ID(idx_closest), idx_closest-offset(idx_closest), X(idx_closest), Y(idx_closest) );                
                    Global_Id = idx_closest;
                    Group_Id = Group_Ids(Global_Id);
                    Local_Id = Local_Ids(Global_Id);
                    if showCurPoint
                        markerSpecs = getGoodSelectMarkerSpecs(hLines(Group_Id));
                        set(hCurPoint, markerSpecs{:});
                    end
%                         assert(Local_Id ==Local_Id_2);
                    
                    if gotFunction
%                         clickFunction(Global_Id, Group_Id, Local_Id, X(Global_Id), Y(Global_Id) );
   
                        clickFunction(Global_Id, Group_Id, Local_Id, X(Global_Id), Y(Global_Id) );
                    end
                    
                    
                    if zoomOutAfterSelection && (curZoomLevel > 1)
                        if slowZoomOut 
                            n = 20;
                            Dx = xlims0 - xlims;
                            Dy = ylims0 - ylims;

                            for i = linspace(0, 1, n)
                                xlim(xlims + Dx*i);
                                ylim(ylims + Dy*i);
                                drawnow;
                            end

                        else
                            xlim(xlims0);
                            ylim(ylims0);
                        end
                        curZoomLevel = 1;
    %                     
                    end

                    done = true;

                    % Zoom in: right click / '<' / '[', or 'x'/'y' (for zooming in only in the x/y axis) )
                    % Zoom out: middle click/shift click/ '>' / ']' or 'X'/'Y'(for zooming out only in the x/y axis)
                case {2,3, 60,62, 91,93, 88,89, 120,121 }   
                    [inOutX, inOutY] = deal(0);
                    if any(button == [3, 60, 91, 88,89]) % zoom in
%                         if button ~= 89,  inOutX = 1;   end
%                         if button ~= 88,  inOutY = 1;   end
                        inOutX = 1;  inOutY = 1;
                    elseif any(button == [2, 62, 93, 120,121]) % zoom out
%                         if button ~= 121, inOutX = -1;  end
%                         if button ~= 120, inOutY = -1;  end
                        inOutX = -1;  inOutY = -1;
                    end
%                     inOut = iff(button == 3, 1, -1);
%                     s = get(cur_fig, 'selectionType');
%                         fprintf('%s\n', s);
                    inOut = inOutX;
                    curZoomLevel = cycle(curZoomLevel, 1:maxZoomLevel, inOut);
                    if curZoomLevel > 1
                        x_window = (diff(xlims) / (zoom_factor ^ inOutX ))/2;
                        y_window = (diff(ylims) / (zoom_factor ^ inOutY ))/2;
                        xlim( cur_x + [-x_window, + x_window]);
                        ylim( cur_y + [-y_window, + y_window]);
                    else
                        xlim(xlims0);
                        ylim(ylims0);
                        if resetAxesWhenZoomingOut
                            set(cur_ax, 'xlimmode', 'auto', 'ylimmode', 'auto')
                        end

                    end

                    xlims = xlim;
                    ylims = ylim;
            end  % switch
            
            
        end 
        
        userData{4} = curZoomLevel;
        set(cur_fig, 'userData', userData);
        if showZoomLevelInFigureTitle
            set(cur_fig, 'name', sprintf('%d Zoom (%dx)', curZoomLevel, zoom_factor^curZoomLevel ));
        end

    end  % while not done
    
end


function specs = getGoodSelectMarkerSpecs(hLine)    
    lineType = get(hLine, 'type');
    if strcmp(lineType, 'line')
        properties = get(hLine, {'markerSize', 'color', 'markerEdgeColor', 'markerFaceColor', 'marker'});                
        [mkSize, mkColor, mkEdgeCol, mkFaceCol, mkShape] = properties{:};
    elseif strcmp(lineType, 'hggroup') % scatter group 
        properties = get(hLine, {'sizeData', 'CData', 'markerEdgeColor', 'markerFaceColor', 'marker'});        
        [mkSize, mkColor, mkEdgeCol, mkFaceCol, mkShape] = properties{:};
        mkSize = sqrt(max(mkSize)); % take the size of the largest point
        mkColor = mkColor(1,:); % take the color of the first point
    end        
    mkSize = max(mkSize, 6);

    if strcmp(mkEdgeCol, 'auto')
%         mkEdgeCol = mkColor;
        mkEdgeCol = 'k';
    end
    
    if strcmp(mkFaceCol, 'none')  % make selector marker a star of same color & same size
%         selMkShape = '*';        
        selMkShape = 's';        
        selMkSize = mkSize;
        
    elseif ~strcmp(mkShape, 's') % make selector marker a square of same size to encompass marker
        selMkShape = 's';        
        selMkSize = mkSize;
        
    elseif strcmp(mkShape, 's') % make selector marker a circle that is larger than current marker
        selMkShape = 'o';        
        selMkSize = mkSize+3;
%         if selMkSize == 4
%             selMkSize = 5;
%         end
        % size groups: [1; 2 3 4; 5; 6 7; 8; 9 10; 11; 12 13; 14;  15 16;  17;  18 19 ...]
    end
    specs = {'color', mkEdgeCol, 'marker', selMkShape, 'markerSize', selMkSize};    

end

function printSelected(offset_id, id, x, y)
    fprintf('[%d:%d], (%.2f, %.2f)\n', id, offset_id, x, y );
end


function [x, y] = axaspect(ax)
    if nargin < 1
        ax = gca;
    end
    old_units = get(ax, 'units');
    set(ax, 'units', 'pixels');
    
    p = get(ax, 'position');
    x = p(3);
    y = p(4);    
    if nargout < 2
        x = y/x;
    end        
    set(ax, 'units', old_units);
end