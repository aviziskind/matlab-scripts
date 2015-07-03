function s = fsep
    persistent fileseparator
    if isempty(fileseparator)
        fileseparator = filesep;
    end
    
    s = fileseparator;
end