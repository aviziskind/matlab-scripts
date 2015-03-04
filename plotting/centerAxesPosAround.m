function centerAxesPosAround(ax, xy, units) 
    if nargin < 3
        units = 'normalized';
    end 
    units_orig = get(ax, 'units');
    set(ax, 'units', units);
    p = get(ax, 'position');
    p_wid = p(3);
    p_hgt = p(4);
    p(1) = xy(1)-p_wid/2;
    p(2) = xy(2)-p_hgt/2;
    set(ax, 'units', units_orig);
end


