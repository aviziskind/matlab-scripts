function all_lock_files = lock_getAllLocks(lock_name)
    if nargin < 1    
        lock_name = '';
    end

    lock_name = lock_removeInvalidChars(lock_name);
    all_lock_files = {};
    
    ls_cmd = [lock_dir() lock_name '*.lock*'];
%     if debug_locks 
%         print(ls_cmd)
%     end
    
    s = dir(ls_cmd);
    if isempty(s)
        return;
    else
        all_lock_files = {s.name};
    end
%     all_lock_files = strings2table(ls_output)
%     for i = 1:length(all_lock_files)
%         all_lock_files{k} = paths.basename(v)
%     end
end


