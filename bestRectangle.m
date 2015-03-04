function [a,b] = bestRectangle(N)
    fs = fliplr(factor(N));
    if length(fs) == 1
        a = 1;
        b = N;
    else 
        a = fs(1);
        b = fs(2);
        i = 3;
        while i <= length(fs)
            if a > b
                b = b * fs(i);
            else
                a = a * fs(i);
            end
            i = i+1;
        end
    end
    
end