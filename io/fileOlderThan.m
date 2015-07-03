function tf = fileOlderThan(file1, file2)    
    if iscellstr(file1) && iscellstr(file2)
        tf = cellfun(@(f1, f2) fileOlderThan(f1, f2), file1, file2);
        return;
    end

    if ischar(file1)
        s1 = dir(file1);
        if ~isempty(s1)
            datenum1 = s1.datenum;
        else
            datenum1 = nan;
        end
    elseif isnumeric(file1)
        datenum1 = file1;
    end
        
    if ischar(file2)    
        s2 = dir(file2);
        if ~isempty(s2)
            datenum2 = s2.datenum;        
        else
            datenum2 = nan;
        end
    elseif isnumeric(file2)
        datenum2 = file2;
    end
    
    if isnan(datenum1) || isnan(datenum2)
        tf = false;
    else
    
        tf = datenum1 < datenum2;
    end
end