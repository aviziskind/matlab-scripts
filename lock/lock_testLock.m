

function lock_testLock()
    global ID
    if isempty(ID)
        error('Need to test with multiple threads')
    end
    nSecEachExperiment = 5

    waitUntilSync = true


    nExperiments = 10
    for i = 1, nExperiments do
       
        sync = false
        sync_time = 10
        last_t = 0
        while not sync do
            t = math.mod( math.floor(sys.clock()), sync_time)
            if (t == 0) 
                sync = true
            else
                if (t ~= last_t) 
                    last_t = t
                    io.write(string.format('%d,', sync_time - t))
                end
                sys.sleep(.1)
            end
        end
        print('starting', i)
       
       
        lock_name = 'test_experiment' .. i
        file_name = lock_dir .. 'test/file' .. i

        if not paths.filep(file_name) 

            isLocked, otherLockID = lock_createLock(lock_name)

            io.write(string.format('\n\n%s\n', lock_name))

            if isLocked 
                io.write(string.format('  -- Great! We (ID = %s) got lock on %s\n', ID, lock_name))
                
                f = assert( io.open(file_name, 'w') )
                f:close()
                
                io.write('"Creating" the file : ');
                for i = 1,nSecEachExperiment do
                    io.write('.');
                    sys.sleep(1);
                end

                io.write(string.format('  -- We (ID = %s) are done, removing lock on %s\n', ID, lock_name))
                lock_removeLock(lock_name)
            else
                io.write(string.format('  -- Could not lock %s. Another process (ID = %s) has already locket it\n', lock_name, otherLockID))
            end

        end
           
   end
    
    
end
