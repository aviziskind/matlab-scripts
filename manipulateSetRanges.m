function manipulateSetRanges(vHandles, vNames, newRanges)

    if ~iscell(vNames)
        vNames = {vNames};
        newValues = {newRanges};
    end

    changedRanges = false(size(vNames));
    for i = 1:length(vNames)
        vName = vNames{i};
        newRange = newRanges{i};
        
        var_idx = find(strcmp(vName, vHandles.varNames));
        if isempty(var_idx)
            error('"%s" is not one of the names of the variables', vName);
        end
        varH = vHandles(var_idx);
        ui_hnd = varH.vHandles(1);

        switch vHandles(var_idx).varTypes
            case 'slider'
                
                set(vHandles(var_idx), 'value', newNumSteps, 'max', newNumSteps*2, 'sliderstep', 1/(2*newNumSteps)*[1, 1]);        
                
                if ~ibetween(newValues{i}, varH.vMin, varH.vMax);
                    error('New value for variable %s must be between current min (%d) and max (%d)', vName, varH.vMin, varH.vMax)
                end

            case 'checkbox',
                newValue = logical(newValue);
                set(ui_hnd, 'value', newValue);

            case 'popup',
                if ischar(newValue)
                    newValue = find(strcmp(varH.vPopupChoices, newValue));
                    if isempty(newValue)
                        error('%s is not one of the options for variable %s', newValue, vName);
                    end
                end
        end
        curValue = get(ui_hnd, 'value');    
        changedRanges(i) = ~isequal(curValue, newValue);
        
        set(ui_hnd, 'value', newValue);    
    end

    if any(changedRanges)
        vHandles.callUpdateFunction();
    end

end