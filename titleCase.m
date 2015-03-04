function Str = titleCase(str)
    
    if iscell(str)
        Str = cellfun(@titleCase, str, 'UniformOutput', false);
        return;
    end
    
    Str = lower(str);
    Str(1) = upper(Str(1));
        
end