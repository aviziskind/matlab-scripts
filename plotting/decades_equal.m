function decades_equal(hAxes, xyratio)
    if nargin < 1 || isempty(hAxes)
        hAxes = gca;
    end
    
    if ~(strcmp(get(hAxes, 'xscale'), 'log') && strcmp(get(hAxes, 'yscale'), 'log'))
        return;
    end
    
    if nargin < 2 || isempty(xyratio)
        xyratio = 1;
    end
    
%     if (nargin < 2) || isempty(xLimits)
        xLimits = get(hAxes,'XLim');
%     end
%     if (nargin < 3) || isempty(yLimits)
        yLimits = get(hAxes,'YLim');
%     end
    
    logScale = diff(yLimits)/diff(xLimits);
    powerScale = diff(log10(yLimits))/diff(log10(xLimits));
    
    set(hAxes,'Xlim',xLimits,...
        'YLim',yLimits,...
        'DataAspectRatio',[1 logScale/powerScale*xyratio 1]);

end