function s = appendToStr(s, newS, sep)
    if nargin < 3
        sep = '; ';
    end
    if isempty(s)
        s = newS;
    elseif isempty(newS)
        % s = s;
        return
    else
        s = [s sep newS];
    end

end
 
