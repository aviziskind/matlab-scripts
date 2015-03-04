function x = singleCell(C)
    if iscell(C) && (length(C) == 1)
        x = cell2mat(C);
    else
        x = C;
    end
end
    