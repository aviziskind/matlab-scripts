function lock_removeAllLocks()
    s = dir([lock_dir '*.lock*']);
     
    if ~isempty(s)
        delete([lock_dir '*.lock*'])
    end
 
end



