function [basename, id] = lock_getLockName(lock_file_name)
%     idx1, idx2, basename, id
%     --if string.find(lock_file_name, '/') 
    %    lock_file_name = paths.basename(lock_file_name)
%     --end
    idx1 = strfind(lock_file_name, '.lock');
    idx2 = idx1 + length('.lock')-1;
    
%     --print('idxs : ', idx1, idx2, lock_file_name)
    basename = lock_file_name(1:idx2);  %  remove any trailing threadId
    id = lock_file_name(idx2+1 : end);
    
end

