function tf = lock_doesLockFileExist(lock_file_name, allowExt)
    if nargin < 2
        allowExt = false;
    end
    ext = '';
    if allowExt 
        ext = '*';
    end
        
    ls_output = dir([lock_file_name ext]);
%     --print(ls_output)

    if ~isempty(ls_output) && strcmp(s.name, lock_file_name);
%     if (ls_output == lock_file_name) || allowExt 
        tf = true;
    elseif isempty(ls_output); %string.find(ls_output, 'No such file or directory') 
        tf = false;
    else 
        error('file name was: \n   %s\n ls output was : \n   %s\n', lock_file_name, ls_output);  %  can this happen?
    end    
end

