function lock_dir_name = lock_dir()
%%
    
%     lock_dir_name = [strrep(userpath, pathsep, '') filesep 'locks' filesep];
%     lock_dir_name = strrep(lock_dir_name, [filesep filesep], filesep);
    lock_dir_name = [codePath '~locks' filesep 'MATLAB' filesep];
    
    if ~exist(lock_dir_name, 'dir') 
        mkdir(lock_dir_name);
    end

end