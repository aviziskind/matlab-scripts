function tf = isToolboxInstalled(tbox_name)

    persistent version_data;

    if isempty(version_data)
        version_data = ver;
    end
    
    toolbox_names = {version_data.Name}';
    toolbox_names = cellfun(@(s) strrep(s, ' Toolbox', ''), toolbox_names, 'un', 0);
    
    if nargin < 1
        disp(toolbox_names);
        if nargout > 0
            tf = [];
        end
    else    
        tf = any(strcmp(tbox_name, toolbox_names));
    end

end