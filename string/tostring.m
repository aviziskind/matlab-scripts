function s = tostring(x)
    if iscell(x)
        x_C = cellfun(@tostring, x, 'un', 0);
        s = ['{' cellstr2csslist(x_C) '}'];
        
    elseif isstruct(x)
        fn = fieldnames(x);
        vals = struct2cell(x);
        x_C = cellfun(@(f,v) sprintf('%s=%s', f, tostring(v)), fn, vals, 'un', 0);
        s = ['{', cellstr2csslist(x_C) '}'];
    elseif isnumeric(x) || islogical(x)
        if length(x) == 1
            s = num2str(x);
        else
            x_C = arrayfun(@num2str, x, 'un', 0);
            s = ['[' cellstr2csslist(x_C) ']'];
        end        
        
    elseif ischar(x)
        
        s = ['"' x '"' ];
    end
    
    
end