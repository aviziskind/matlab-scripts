function [n, name_example] = lock_nLocksWithThisName(lock_name)
    
    name_example = '';
    locksWithThisName = lock_getAllLocks(lock_name);
    n = length(locksWithThisName);
    if n > 0
        name_example = locksWithThisName{1};
    end
        
end
