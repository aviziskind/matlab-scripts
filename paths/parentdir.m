function s = parentdir(filename)
    idx_sep = strfind(filename, filesep);

    
    if idx_sep(end) == length(filename) 
        idx_last = idx_sep(end-1);
    else
        idx_last = idx_sep(end);
    end
    s = filename(1:idx_last);
    

end