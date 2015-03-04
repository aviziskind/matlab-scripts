function manipulateSet(vHandles, vNames, newValues, requireExactMatch_flag)

    if ~iscell(vNames) % ie. single variable
        vNames = {vNames};
        newValues = {newValues};
    end
    
    requireExactMatch = exist('requireExactMatch_flag', 'var') && ~isempty(requireExactMatch_flag);

    changedVals = false(size(vNames));
    for i = 1:length(vNames)
        vName = vNames{i};
        newValue = newValues{i};
        var_idx = find(strcmp(vName, vHandles.varNames));    
        if isempty(var_idx)
            error('"%s" is not one of the names of the variables', vName);
        end
%         varH = vHandles(var_idx);
        ui_hnds = vHandles.vHandles{var_idx}(1);
        ui_hnd1 = ui_hnds(1);

        switch vHandles.varTypes{var_idx}
            case 'slider'
                if requireExactMatch && (~ibetween(newValues{i}, varH.vMin, varH.vMax));
                    error('New value for variable %s must be between current min (%d) and max (%d)', vName, varH.vMin, varH.vMax)
                end

            case 'checkbox',
                newValue = logical(newValue);
                set(ui_hnd1, 'value', newValue);

            case 'popup',
                if ischar(newValue)
                    newValue = find(strcmp(varH.vPopupChoices, newValue));
                    if isempty(newValue)
                        error('%s is not one of the options for variable %s', newValue, vName);
                    end
                end
        end
        curValue = get(ui_hnd1, 'value');    
        changedVals(i) = ~isequal(curValue, newValue);
        
        if length(ui_hnds) > 1
            newValue = get(ui_hnd1, 'value'); 
%             set(
%             ui_hnd2 = ui_hnd1
        end
                
        set(ui_hnd1, 'value', newValue);
        updateValFunc = get(ui_hnd1,'callback');
        updateValFunc(ui_hnd1, [], 1);
        
%         ui_hnd1.cal, 'value', newValue);
    end

    if any(changedVals)
        vHandles.callUpdateFunction();
    end

end