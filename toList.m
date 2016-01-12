function s = toList(x, nMax, sep)
    if nargin < 2 || isempty(nMax)
        nMax = length(x);
    end
    nMax = min(nMax, length(x));
    x = x(1:nMax);

    if nargin < 3
        sep = '_';
    end
    
        
    if isnumeric(x)
        
        s = [toStr(x, sep)];
        s = s([1:end - length(sep)]);
        
    elseif iscell(x)        
        
        % if any numeric values --> convert to strings
        idx_numeric = cellfun(@isnumeric, x);
        x(idx_numeric) = cellnum2cellstr(x(idx_numeric));
                
        % concatenate strings
        s = cellstr2csslist(x, sep);
        
    end

end



function s = toStr(x, sep)
    
    if x == round(x)
        s = sprintf(['%d' sep], x);
    else
        s = sprintf(['%.1f' sep], x);
    end
    
end

%{
        
        if isnumeric(x{1})
            x = cellnum2cellstr(x);
        end

        if iscell(x) && ischar(x{1})
            x = cellstr2csslist(x, sep);
        end

        s = x;

%}