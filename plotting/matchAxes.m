function matchAxes(whichAxes, varargin)
    % A tool to set the axes limits as the same across different plots.
    % whichAxes: which axes to set the same (eg: 'X', 'Y', 'XY', 'XYZ')
    % varargin: a list of handles to the plots, or the axes containing the 
    % plots for which you want to have the same limits.
    % it can be in a list format (h1, h2, h3), or as a vector [h1, h2, h3]
    hs = cell2mat(varargin);
    hs = hs(:);

    function matchAxis(limTxt)

        function axHnd = getAxHnd(hnd)
            if isprop(hnd, limTxt)
                axHnd = hnd;    % hnd is an axis object
            else
                axHnd = get(hnd, 'Parent'); % hnd is a plot object.
            end
        end
        
        lims = get( getAxHnd(hs(1)), limTxt);
        for hi = 2:length(hs)
            limsNext = get(  getAxHnd(hs(hi)), limTxt);
            lims = [min(lims(1), limsNext(1)),  max(lims(2), limsNext(2))];        
        end

        for hi = 1:length(hs)
            set( getAxHnd(hs(hi)), limTxt, lims);
        end        
    end

    if strfind( upper(whichAxes), 'X')
        matchAxis('xlim');
    end
    if strfind( upper(whichAxes), 'Y')
        matchAxis('ylim');
    end
    if strfind( upper(whichAxes), 'Z')
        matchAxis('zlim');
    end
    if strfind( upper(whichAxes), 'C') % color axis for color plots
        matchAxis('clim');
    end
        
end