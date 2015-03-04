function sf = subfolders(folderName)
    s = dir(folderName);
    s = s([s.isdir]);
    
    idx_cur = find(strcmp({s.name}, '.'));
    idx_prev = find(strcmp({s.name}, '..'));
    s([idx_cur, idx_prev]) = [];

    sf = {s.name};

end