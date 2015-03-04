function hnd = plotOrUpdatePlot(hnd, xdata, ydata, varargin)
    if isempty(hnd) || ~ishandle(hnd)
        hnd = plot(xdata, ydata, varargin{:} );
    else
        set(hnd, 'xdata', xdata, 'ydata', ydata );
    end
end
