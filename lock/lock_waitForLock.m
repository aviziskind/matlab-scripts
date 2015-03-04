function lock_waitForLock(lock_name, waitIntervals_sec)
    lock_name = lock_removeInvalidChars(lock_name);
    
    ourLockFileName = lock_getLockFileName(lock_name, true);
    weHaveALock = lock_doesLockFileExist( [lock_dir  ourLockFileName] );
            
    if weHaveALock 
        tf = true;
        return
    end
    
    otherLockFileName_base = lock_getLockFileName(lock_name, false);
    if nargin < 2
        waitIntervals_sec = 5;
    end
    
    firstTry = true;
    gotLockYet = false;
    while ~gotLockYet 
        gotLockYet = lock_createLock(lock_name);
        
        if ~gotLockYet 
            if firstTry 
                fprintf(' [Another process has lock [%s]. Waiting for it to be free :] \n  ', lock_name)
                firstTry = false;
            end
            
            pause(waitIntervals_sec)
            fprintf('.');
        end
    end
    
        
    
end
