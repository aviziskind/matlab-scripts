function centerAxisLimsAround(X)
    [x, y] = elements(X);
    Dx = diff(xlim);
    Dy = diff(ylim);
    axis([x - Dx/2, x + Dx/2, y - Dy/2, y + Dy/2]);
end
