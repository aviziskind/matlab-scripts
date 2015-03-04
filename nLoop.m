function [y, done] = nLoop(x, lims)
    done = all(x >= lims);
    y = x;
    j = length(y);
    y(j) = y(j)+1;
    while (y(j) > lims(j))
        y(j) = 1;
        j = j-1;
        if j == 0
            done = true;
            return;
        end
        y(j) = y(j) + 1;
    end            
    
end
