function box = corners2box(xy_c1, xy_c2)
    boxLL = [min(xy_c1(1), xy_c2(1)), ...
             min(xy_c1(2), xy_c2(2))];
    boxUR = [max(xy_c1(1), xy_c2(1)), ...
             max(xy_c1(2), xy_c2(2))];
    box = [boxLL, boxUR-boxLL];
end