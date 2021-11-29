function nMB = memoryAvailable_MB()

    
    if ispc 
        m = memory;
        nMB = m.MemAvailableAllArrays / (1024^2);
        
    else
    
%                         system('echo `free -m | grep Mem` | cut -d " " -f 4')  -- doesn't take into account buffers/cache
%         [status,result]= system( 'echo `free -m | grep "buffers/cache"` | cut -d " " -f 4' );
        [status,result]= system( 'cat /proc/meminfo' );
        memory_info_C = strsplit(result, '\n')';
        if status ~= 0 
            error('Could not get memory')
        end
% 
        %%
        mem_info_S = struct;
        for i = 1:length(memory_info_C)
            A = regexp(memory_info_C{i}, '(\w+): +(\d+)', 'tokens', 'once');
            if ~isempty(A)
                mem_info_S.(A{1}) = str2double(A{2});
            end
        end
        
        if isfield(mem_info_S, 'MemAvailable')
            nMB = mem_info_S.MemAvailable / 1024;
        else
            nMB = (mem_info_S.MemFree + mem_info_S.Buffers)/1024;
        end 
        
        %%
        
    end
    
end


