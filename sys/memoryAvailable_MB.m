function nMB = memoryAvailable_MB()

    
    if ispc 
        m = memory;
        nMB = m.MemAvailableAllArrays / (1024^2);
        
    else
    
%                         system('echo `free -m | grep Mem` | cut -d " " -f 4')  -- doesn't take into account buffers/cache
        [status,result]= system( 'echo `free -m | grep "buffers/cache"` | cut -d " " -f 4' );
        if status ~= 0 
            error('Could not get memory')
        end
        nMB = str2double(result);
    
    end
    
end


