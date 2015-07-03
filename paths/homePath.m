function s = homePath
    
    persistent homePath_str
    
    if isempty(homePath_str)
        if ispc
            user_profile = getenv('USERPROFILE');
            if isXPS15
                user_profile = strrep(user_profile, 'C:\', 'D:\');
            end
            homePath_str = [user_profile filesep];
        else    
            homePath_str = [getenv('HOME') filesep]; 
        end
    end
    
    
    s = homePath_str;
    
end