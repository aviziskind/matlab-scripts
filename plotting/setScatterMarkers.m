function setScatterMarkers(hnd, markers, pointsIdx)

    if (length(markers) == 1) && (nargin < 3) % set all points to the designated marker.
        set(hnd, 'marker', markers);
        return;
    end
        
    ch = get(hnd, 'children');
    nCh = length(ch);
    if nargin < 3
        pointsIdx = 1:nCh;
    end        

    if length(pointsIdx) ~= length(markers)
        error('number of markers much match number of points');
    end
    for i = 1:length(pointsIdx)
        set(ch(pointsIdx(i)), 'marker', markers(i))
    end
    
end


