function profilePath(cmd, pathname)
    %eg: profilePath;  % lists the available profiles
    %eg: profilePath('load', 'CatV1Exp')
    %eg: profilePath('save', 'miller')
    %eg: profilePath('restore')
    global host
    
    alwaysRedoBuiltinPath = false;
%     changeOldMatlabPathToNew = 1;
    
    savePathsInRelativeFormat = 1;
    savePreviousPath = false;

    codepath_abs = codePath;
%     if ispc    
% %         codepath_laptop = 'D:\Users\Avi\Code';
%         codepath_laptop = 'F:';
%     else
% %         codepath_laptop = '/f';
%         codepath_laptop = '/media/avi/Storage/Users/Avi/Code';
%     end
%     codepath_nyu    = '~/f/'; % '/home/ziskind/Code/MATLAB'; or '~/Code/MATLAB'
%     onNYUserver
%     [~, hostname] = system('hostname');
%     if strncmp(hostname, 'XPS', 3)  
%         hostname = 'XPS';
%         codepath_abs = codepath_laptop;
%     else
%         hostname = 'nyu_edu';
%         codepath_abs = codepath_nyu;
%     end
    
    filesep_save = '/';  % always save fileseparator in the same format, whether in unix/windows
    
    matlab_version = version('-release');
    
%     pathFileName = [strtok(userpath, pathsep) filesep 'profilePath_data_' computer '.mat'];
%     pathFileName = [home_dir filesep 'profilePath_data_' computer '.mat'];
%     pathFileName = [homePath 'Code' filesep 'MATLAB' filesep 'profilePath_data_' computer '.mat'];
    
%     pathFileName = [homePath 'Code' filesep 'MATLAB' filesep 'profilePath_data.mat'];
%     pathFileName = [homePath 'Code' filesep 'MATLAB' filesep 'profilePath_data.mat'];
    pathFileName = [codePath 'scripts' filesep 'MATLAB' filesep 'paths' filesep 'profilePath_data.mat'];
    
    if exist(pathFileName, 'file')
        S = load(pathFileName);
    else
        S = struct;
    end
    if nargin == 0,
        cmd = 'list';
    end
    builtinPathName = ['R' matlab_version '_' host '_' computer '_builtin_path'];
    if ~isfield(S, builtinPathName) || alwaysRedoBuiltinPath
        curBuiltinPath = getBuiltinMatlabPaths;
        S.(builtinPathName) = curBuiltinPath;
        save(pathFileName, '-struct', 'S');
    else
        curBuiltinPath = S.(builtinPathName);
    end

    
%     absolutePaths.codepath = {codepath_abs, codepath_laptop, codepath_nyu, '/home/avi/Code' };
    absolutePaths.codepath = {codepath_abs };
    pathsReplace.myscripts = 'scripts';

%     absolutePaths.codepath = {codepath_abs, codepath_laptop, codepath_nyu, '/home/avi/Code/', strrep(userpath, ':', '') };
%     absolutePaths.userpath = {strrep(userpath, ':', '')};

    
    switch cmd
        case 'save'
            curPath = removeBuiltinMatlabPaths( path );            
            if savePathsInRelativeFormat
                curPath = convertToRelativeFormat(curPath, absolutePaths);
                curPath = convertFileSep(curPath, filesep, filesep_save);
%               


                3;
            end
            varname = [pathname '_path'];
            S.(varname) = curPath;
            
            save(pathFileName, '-struct', 'S');
            disp(['Successfully saved "' pathname '" profile path']);        
            
        case 'load'
            previous_path = removeBuiltinMatlabPaths( path );            
            if ~strcmp(pathname, 'builtin')
                varname = [pathname '_path'];
                if isfield(S, varname)
                    newPath_loaded = S.(varname);
%                     newPath_loaded = fixPath_tmp(newPath_loaded);
                    newPath_loaded = sort(newPath_loaded);
                    
                    if savePathsInRelativeFormat
                        newPath_loaded = convertToAbsoluteFormat(newPath_loaded, absolutePaths);
                    end
                    
                    
                    if exist('pathsReplace', 'var')
                        strs = fieldnames(pathsReplace);
                        for i = 1:length(strs)
                            str_target = strs{i};
                            str_dest   = pathsReplace.(str_target);
                            for j = 1:length(newPath_loaded)
                                if ~isempty(strfind(newPath_loaded{j}, str_target))
                                    newPath_loaded{j} = strrep(newPath_loaded{j}, str_target, str_dest);
                                end
                            end
                        end
                    end
                    
                    newPath = [newPath_loaded; curBuiltinPath];
                else
                    error(['No path profile named ' pathname ' exists.']);
                end                               
            else
                newPath = curBuiltinPath;
            end
            
            newPath = convertFileSep(newPath, filesep_save, filesep);
           
            %{
            if changeOldMatlabPathToNew
                old_dir = 'C:\Users\Avi\Documents\MATLAB';
                new_dir = 'D:\Users\Avi\Code\MATLAB';
               for i = 1:length(newPath) 
                    if ~isempty(strfind( newPath{i}, old_dir ))
                        newPath{i} = strrep(newPath{i}, old_dir, new_dir);
                    end
               end
            end
            %}
            path( cellarray2strlist(newPath) );
            if savePreviousPath
                S.previous_path = previous_path;

                save(pathFileName, '-struct', 'S');
            end
            disp(['Successfully loaded "' pathname '" profile path']);            
        case 'restore'
            varname = 'previous_path';
            if isfield(S, varname)
                prevPath = cellarray2strlist( [S.(varname); curBuiltinPath]);
                path(prevPath);
            else
                error(['No previous path ' pathname ' exists.']);
            end                        
            disp(['Successfully restored previous profile path']);

        case 'delete'
            varname = [pathname '_path'];
            if isfield(S, varname)
                yn = input(['Are you sure you want to delete the profile "' varname2 '" ? [Y/N] '], 's');
                if strcmpi(yn, 'Y')
                    S = rmfield(S, varname);                    
                    disp(['Profile "' pathname '" deleted']);
                end
            else
                disp(['Profile "' pathname '" not found']);                
            end
            save(pathFileName, '-struct', 'S');
            
        case 'list'
            nPathsPerList = cellfun(@length, struct2cell(S), 'un', 0);
            pathLists = fieldnames(S);
            pathLists = cellfun(@(fn, n) [strtok(fn, '_') ' (' num2str(n) ' entries)'], pathLists, nPathsPerList, 'Un', false);
            idx_builtins = cellfun(@(s) strncmp(s, 'R20', 3), pathLists);
            pathLists = pathLists(~idx_builtins);
            pathLists = setdiff(pathLists, 'previous');
            pathLists{end+1} = ['[' matlab_version ' default path (' num2str(length(curBuiltinPath)) ' entries)  (type "builtin")]'];
            
            disp(['Available profiles are :']);
            disp(pathLists(:));
            disp('');
    
        otherwise
            error('First input must be either "load", "save", "delete" or "restore" (or "list")');
    end
    
    
    
    
end

function C = strlist2cellarray(S, sep)
    i = 1; 
    while ~isempty(S), 
        [C{i}, S] = strtok(S, sep); 
        i = i+1; 
    end;
    C = C';
end
function S = cellarray2strlist(C)
    S = '';
    for i = 1:length(C)
    	S = [S ';' C{i}];
    end
end

function pathList_C = removeBuiltinMatlabPaths(pathList)
    if ischar(pathList)
        pathList = strlist2cellarray(pathList, pathsep);
    end
    idx = cellfun(@(s) isempty(strfind(s, matlabroot)), pathList);
    pathList_C = pathList(idx); 
end

function pathList_C = convertToRelativeFormat(pathList_C, absolutePaths)
    
    flds = fieldnames(absolutePaths);
    nFlds = length(flds);
    for path_i = 1:length(pathList_C)
        for fi = 1:nFlds
            fld_name = flds{fi};
            C = absolutePaths.(fld_name);
            for opt_i = 1:length(C)
                if ~isempty(strfind( pathList_C{path_i}, C{opt_i}) )
                    newPath = strrep(pathList_C{path_i}, C{opt_i}, ['%' fld_name '%']);
                    pathList_C{path_i} = newPath;
                end
            end
        end
    end
    
    
end

function pathList_C = convertFileSep(pathList_C, filesep_src, filesep_dst)
    if strcmp(filesep_src, filesep_dst)
        return
    end
    
    for i = 1:length(pathList_C)
        pathList_C{i} = strrep(pathList_C{i}, filesep_src, filesep_dst);
    end
end


function pathList_C = convertToAbsoluteFormat(pathList_C, absolutePaths)
    
    flds = fieldnames(absolutePaths);
    nFlds = length(flds);
    for path_i = 1:length(pathList_C)
        for fi = 1:nFlds
            s_place_holder = sprintf('%%%s%%', flds{fi});
            s_abs_path = absolutePaths.(flds{fi}){1};
            
            if ~isempty(strfind( pathList_C{path_i}, s_place_holder) )
%                 if strcmp(flds{fi}, 'userpath')
%                     s_use = userpath_abs;
%                 else
%                     s_use = strrep( eval(flds{fi}), ':', '');
%                 end
            
                newPath = strrep(pathList_C{path_i}, s_place_holder, s_abs_path);
                pathList_C{path_i} = newPath;
                
            end
        end
    end
    
    
end


function C_builtin = getBuiltinMatlabPaths
%     matlabroot = 'C:\Program Files\MATLAB\';
%%
    path_C = strlist2cellarray(path, pathsep);
    idx = cellfun(@(s) ~isempty(strfind(s, matlabroot)), path_C);
    C_builtin = path_C(idx); 
    
end


% S = load('paths_R2008b');
% s = S.myscripts_path;
% 
% C = {};
% i = 1; 
% while ~isempty(s), 
%     [C{i}, s] = strtok(s, ';'); 
%     i = i+1; 
% end;
% matlabBase = 'C:\Program Files\MATLAB\';
% idx = cellfun(@(s) isempty(strfind(s, matlabBase)), C);
% C = C(idx); 
% 
% myscripts_path = C;