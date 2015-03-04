function lock_removeMyLocks()
    global ID
    
    if ~isempty(ID)
        thread_id_str = ID;
    else
        thread_id_str = '';
    end
    
    s = dir([lock_dir '*.lock' thread_id_str]);
    if ~isempty(s)

        fprintf('removed these locks : \n ');
        
        for i = 1:length(s)
            fprintf('%s\n', s(i).name);
            delete([lock_dir s(i).name]);
        end
%         system(['rm '  lock_dir  '*.lock' thread_id_str])    
    else
        fprintf('No Locks held by this matlab session\n')
    end
 
end

