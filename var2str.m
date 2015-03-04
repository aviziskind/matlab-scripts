function s = var2str(v)
    if isnumeric(v)
        s = num2str(v);
        return;
    end

    switch class(v)
        case 'char'
            s = ['''' v ''''];
        case 'function_handle'
            s = ['@' func2str(v)];
            s = strrep(s, '@@', '@');
        case 'logical'
            if v,
                s = 'true';
            else
                s = 'false';
            end
        case 'cell'  
            s = cellfun(@var2str, v, 'UniformOutput', false);  % recursively apply this function to each cell element
            spc = [repmat({', '}, 1, length(s)-1), {''}];
            s_spc = [s(:)'; spc];
            s = ['{' s_spc{:} '}'];    
    end
    
end