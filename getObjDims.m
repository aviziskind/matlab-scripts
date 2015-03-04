function wid_height = getObjDims(h, units)
    origUnits = get(h, 'units');
    diff_units = ~strcmp(origUnits, units);
    if diff_units
        set(h, 'units', units);
    end
    pos = get(h, 'position');
    wid_height = pos(3:4);
    if diff_units
        set(h, 'units', origUnits);
    end
end