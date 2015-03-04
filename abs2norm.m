function normPoint = norm2abs(absPoint)
    [ax_left ax_bottom ax_width ax_height] = elements(get(gca, 'Position'));
    [x1, x2, y1, y2] = elements(axis);
    
    normX = ax_left   + (absPoint(1)-x1)/(x2-x1) * ax_width;
    normY = ax_bottom + (absPoint(2)-y1)/(y2-y1) * ax_height; 

    normPoint = [normX; normY];
end