function lock_removeLock(lock_name)
    lock_name = lock_removeInvalidChars(lock_name);
    
    lock_file_name_withID = lock_getLockFileName(lock_name, true);
%     --print('removing: ', lock_name, lock_file_name_withID)
    
    delete([lock_dir lock_file_name_withID]);
end

