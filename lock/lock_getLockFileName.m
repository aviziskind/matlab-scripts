function filename = lock_getLockFileName(lock_name, addThreadId)
    global ID
    filename = [lock_name '.lock'];
    if addThreadId && ~isempty(ID)
       filename = [filename ID];
    end
    
end

