function hout = histcplot(x, xedges)
    x = nonnans(x);
%     if ~( all( abs(diff(xedges, 2)) < 1e-5) );
%         error('edges must be evenly spaced')
%     end

    n = histc(x, xedges);
    n(end-1) = n(end-1) + n(end);   n(end) = [];   % put last bin value into prev bin.
    xcent = xedges(1:end-1) + diff(xedges)/2; 
    h = bar(xcent, n, 1);
    xlim([xedges(1) xedges(end)]);   
    if nargout == 1
        hout = h;
    end
end



%     n = histc(x, xedges);
%     h = bar(edges, n, 'histc');
%     if nargout == 1
%         hout = h;
%     end
