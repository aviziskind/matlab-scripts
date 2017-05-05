function [tf, otherLockID] = lock_createLock(lock_name)
    global ID
    %  lock_name = 'this_experiment'
    %  lock_file_name = 'this_experiment.lock'
    %  lock_file_name_withID = 'this_experiment.lock4'


    % debug_locks = false;
    % debug_mode = false;
    
    otherLockID = '';
    %  try mark this experiment as being worked on:
    %  (1) check if any other processes have staked a claim on this experiment (if yes -> return false). if lock is from us, continue
    lock_name = lock_removeInvalidChars(lock_name);
    
    
    lock_file_name = lock_getLockFileName(lock_name, false); %  don't add ThreadID
    
    [nLocksWithSameBase_AtStart, lock_example] = lock_nLocksWithThisName(lock_name);
%     if debug_locks 
%         fprintf('At start, there are %d locks with the same name)\n', nLocksWithSameBase_AtStart);
%     end
        
    secondsToWaitAfterCreatingLock = 2;

        
    if nLocksWithSameBase_AtStart > 0 
    
        allLocksWithSameName = lock_getAllLocks(lock_name);
%         if debug_locks 
%             fprintf('Here are all the locks with the same name:\n')
%             fprintf(allLocksWithSameName);
%         end
        for lock_i = 1:length(allLocksWithSameName)
            lockFileName_i_withID = allLocksWithSameName{lock_i};
            [lockFileName_i, id_i] = lock_getLockName( lockFileName_i_withID );
            
            if strcmp(lockFileName_i, lock_file_name) && strcmp(id_i, ID)  %  we locked this before, and can now resume
                fprintf('    [Reclaiming lock (%s)]\n', lock_name)
                tf = true;
                return
            end
        end
        
        %  there were locks, and they were not ours --> exit.
        if ~isempty(allLocksWithSameName)
            [~, otherLockID] = lock_getLockName(allLocksWithSameName{1});
        else  % (other lock was deleted already before counted for the second time.)
            otherLockID = lock_example;
        end
        tf = false;  % "false"=could not place a lock because another process already has a lock.
        return 
    end
    
    
    %  (2) if none, stake a claim; wait for a second, and make sure no one else has staked a claim in the meantime 
    lock_file_name_withID = lock_getLockFileName(lock_name, true); %  this time, add ThreadID 
    fid = fopen([lock_dir lock_file_name_withID], 'w');
    fclose(fid);
    fprintf('    [Just created a lock : %s]\n', lock_file_name_withID);
        
    if ~onLaptop
        pause(secondsToWaitAfterCreatingLock);
    end
    
  %  allLocks2 = lock_getAllLocks()
  %  nLocksWithSameBase_AfterLocked = nInTableThatSatisfy(allLocks2, lock_getLockName, lock_file_name)
    
    
    
    % [[ 
%         repeat checking until either 
%             (1) we're the only one retaining the lock % > return true, or we find another    
    % ]]
    
   
    nLocksWithSameBase = lock_nLocksWithThisName(lock_name);
%     if debug_locks 
%         fprintf('After opening, there are %d locks with the same name)', nLocksWithSameBase);
%     end

    
    
    nTriesMAX = 3;
    try_id = 1;
    
    while try_id <= nTriesMAX 
        [nLocksWithSameBase, lockFileNameExample] = lock_nLocksWithThisName(lock_name);
       
        if nLocksWithSameBase == 1 && strcmp(lockFileNameExample, lock_file_name_withID)  
            % (3a) (if no other process placed the same lock -> return true)
            tf = true;
            return
        
        elseif (nLocksWithSameBase== 0) 
            % (3b) wait a few more seconds for the file to register, perhaps?
            pause(secondsToWaitAfterCreatingLock*2) 
        
        elseif nLocksWithSameBase > 1 || ~strcmp(lockFileNameExample, lock_file_name_withID)  
        % (3c) if other processes have tried to place a lock, check whose threadId is higher (if current process has a higher threadId, return true; otherwise, delete lock and return false)
            fprintf('conflict!\n')
            allLocksWithThisName2 = lock_getAllLocks(lock_name);
            for i = 1:length(allLocksWithThisName2)
                lock_i = allLocksWithThisName2{i};
                
                [base_i, id_i] = lock_getLockName(lock_i);
                assert(strcmp(base_i, lock_file_name))
                str_sign = strcmp_lex(id_i, ID);
                if str_sign == 1 %  another process has beaten us.
                    fprintf('Thread %s has priority over us (%s). Conceding lock ...\n ', id_i, ID)

                    lock_removeLock(lock_name)
                    tf = false;
                    otherLockID = id_i;
                    return 
                    
                elseif str_sign == -1  %  we take priority
                    fprintf('We (thread %s) take priority over thread %s. Waiting for thread %s to concede ... \n', ID, id_i, id_i)
                    pause(secondsToWaitAfterCreatingLock) 
                elseif str_sign == 0; % (this is our own thread; ignore)
                    continue;
                end
            end        
        end
        
        %  no threads took priority over us, so we successfully retained the lock!
        try_id = try_id + 1;
    end
    
    
    if (nLocksWithSameBase== 0) 
        fprintf('Could not place a lock for some reason ..? Abandonding lock...\n')
            % (3b) wait a few more seconds for the file to register, perhaps?
        tf = false;
        return
    end    
    if nLocksWithSameBase > 1  %  other thread didn't concede -- give up
        
        lock_removeLock(lock_name);
        
        [~, otherLockName] = lock_nLocksWithThisName(lock_name);
        [~, otherLockID] = lock_getLockName(otherLockName);
        
        fprintf('Other thread(s) [ID = %s] did not concede. Abandonding lock...', otherLockID);
        tf = false;
        return
    end
    
    error('Shouldnt get to this point')
        
                    
end





function tf = haveAnyLockWithThisBase(lock_name)
    lock_name = lock_removeInvalidChars(lock_name);
    
    withID = true;
    lock_file_name = lock_getLockFileName(lock_name, withID);
    tf = lock_doesLockFileExist( [lock_dir lock_file_name], true );
    
end

function tf = lock_haveThisLock(lock_name)
    lock_name = lock_removeInvalidChars(lock_name);
    
    withID = true;
    lock_file_name = lock_getLockFileName(lock_name, withID);
    tf = lock_doesLockFileExist( [lock_dir lock_file_name], true );
    
end


