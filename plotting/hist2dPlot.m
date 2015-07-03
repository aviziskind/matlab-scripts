function hist2dPlot(Z, xedges, yedges, plotFlag)
    shadingOptions = {'monochrome', 'interp'};
    shadingOption = shadingOptions{2};
    [nX, nY] = size(Z);
    
    if exist('plotFlag', 'var') && strcmp(plotFlag, 'logplot')
        h = bar3(log10(Z'), 'histc');
    else
        h = bar3(Z', 'histc');
    end
    set(gca, 'Ydir', 'normal');
    xlabel('x');
    ylabel('y');
    
    % 1. fix x & y axes:
    %     scale: from (.5 -> nX +0.5)   ==>  (xedges(1):xedges(end) )
    rescalex = @(x)  rescale(x, 0.5+[0, nX], xedges);
    rescaley = @(y)  rescale(y, 0.5+[0, nY], yedges);
    
    xs= get(h, 'xdata');
    ys= get(h, 'ydata');
    for i = 1:length(h)
        set(h(i), 'xdata', rescalex(xs{i}), 'ydata', rescaley(ys{i}));
    end
    axis([xedges(1), xedges(end), yedges(1), yedges(end)]);
    view(3);
    
    set(gca, 'xtick', linspace(xedges(1), xedges(end), 5));
    set(gca, 'ytick', linspace(yedges(1), yedges(end), 5));
    
    % 2. adjust shading;
    if strcmp(shadingOption, 'monochrome')

        for i = 1:length(h)
            zdata = ones(6*length(h),4);
            k = 1;
            for j = 0:6:(6*length(h)-6)
                zdata(j+1:j+6,:) = Z(k,i);
                k = k+1;
            end
            set(h(i),'Cdata',zdata)
        end

    elseif strcmp(shadingOption, 'interp')
        shading interp
        for i = 1:length(h)
            zdata = get(h(i),'Zdata');
            set(h(i),'Cdata',zdata)
            set(h,'EdgeColor','k')
        end

    end

    colormap cool
%     colorbar

end

