function vHandles = manipulate(updateFuncHandle, variableList, varargin)
%{ 
Allows interactive manipulation of a set of variables.
(inspired by the Mathematica "manipulate" command.)

This function creates a control panel in a new figure, with
uicontrols that allow you to explore a set of parameters
interactively and in real time. 

Inputs:
* updateFuncHandle : this should be the handle to a function that
  you have defined prior to calling this function. It should accept as inputs all
  the parameters that you wish to control.

* variableList : this should be a cell array containing all the arguments to be
    passed to the function. (in the same order as they are passed to the
    function). Each argument should consist of its own cell array, in the 
    following format : 
    {paramName, valueRange, [initialValue], [dependent variables lists], [description(s)]}     
    ** paramName - the name of the parameter - this will be displayed
       on the control panel so you know which parameter it is.
    
    ** depending on the type of variable you wish to control, you should
    supply the following combination of inputs for valueRange (and,
    optionally, the [initialValue])
    (1) a scalar : (controlled by a slider)
            valueRange = a vector of numeric values that the scalar can take, eg [1:10]. 
            initialValue = the value that the variable will start off with (eg [5]) 
    (2) a vector: (controlled by multiple sliders)
            valueRange = either (a) a matrix, with one row for each element 
                        or (b) a cell array of vectors, one for each element. 
            initialValue = a vector with initial values for each element
    (2) a single boolean /logical value: (controlled by a check-box)
          valueRange = either (a) a matrix, with one row for each element 
                           or (b) a cell array of vectors, one for each element. 
            initialValue = a vector with initial values for each element    

%}

    
    paramNames  = {'Title', 'FigId', 'Groups', 'initialCall'};
    defaultVals = {'',       [],     {},        true };
    [figureTitle, figId, varGroups, initialCall] = parseArgValuePairs(paramNames, defaultVals, varargin{:});
    defaultSaveName = [figureTitle '.mat'];

        
    % Input # 1: the Function handle
    if ~isa(updateFuncHandle, 'function_handle')
        error('Input #1 must be a function_handle');
    end
    
    % Input #2. Parse the variables provided
    if ~iscell(variableList) 
        error('Input #2 must be a cell array of properly-formatted variable inputs');
    end 
            
    if isProperInputArg(variableList) % if only 1 input, and is in a nested cell array.
        variableList = {variableList};
    end
    
    varNames = cellfun(@(c) c{1}, variableList, 'Un', false);
    % make sure no variables were accidentally provided more than once:
    if length(unique(varNames)) < length(varNames)
        [uVarNames, m, idx_orig] = uniqueCount(varNames);        
        duplicateIdxs =  arrayfun (@(i) nnz(idx_orig==i)>1, 1:length(uVarNames)) ;
        dupVarStr = cellfun(@(s) [s, '; '], uVarNames(duplicateIdxs), 'un', 0);
        error('Error: duplicate definitions of these inputs %s', [dupVarStr{:}]);
    end
    nVars = length(variableList);

    % Variable types
    WAIT = 1;
    
    groupAllArgsIntoCell = false;

    % if "Groups" variable provided, arrange variables into groups
    nGroups = length(varGroups);    
    if ~isempty(varGroups)        
        gVarIds = cell(1,nGroups);
        vGroup = zeros(nVars, 1);
        vGroupVisible = true(nGroups, 1);
                
        for group_i = 1:nGroups
            for group_var_i = 1:length(varGroups{group_i})
                var_id = find(strcmp(varGroups{group_i}{group_var_i}, varNames));
                if isempty(var_id)
                    error(['"' varGroups{group_i}{group_var_i} ' was included in one of the variable groups, but it is not one of the arguments supplied to the function.']);
                end
                gVarIds{group_i}(group_var_i) = varId;
                if (vGroup(var_id) ~= 0)
                    error(['Variable "' strcell(varNames(var_id)) '" is in groups ' num2str(vGroup(var_id)) ' and ' num2str(group_i) ' (but is only allowed to be in 1 group).']);
                end
                vGroup(var_id) = group_i;
            end
            gVarIds{group_i} = sort(gVarIds{group_i});
            if any(diff(gVarIds{group_i}) ~= 1)
                error('Variables in group # %d must be consecutive order', group_i);
            end
        end
    end                    
    
    % All the workspace variables that will be needed for the control-panel variables
    varValues = cell(nVars, 1);        
    varTypes = cell(nVars, 1);
    vIsConst = cell(nVars, 1);   % if const (ie. can only have 1 value), the variable will not be displayed
    vNumElements = ones(nVars,1);
    vIsVector = false(nVars, 1);
    vUniform   = cell(nVars, 1);   % for vector variables, specifies whether values are spaced out uniformly (if so, don't need to explicitly store each value).
    vMin  = cell(nVars, 1);     % for (uniform) numeric variables : store min, max, and step size
    vMax  = cell(nVars, 1);
    vStep = cell(nVars, 1);
    vNUvals    = cell(nVars, 1);   % values for non-uniform variables (need to store all values)
    vNUcurIdx  = cell(nVars, 1);   % current value-index for non-uniform variables
    
    vStrFormat = cell(nVars, 1);    % the display string format when converting numbers to strings
    vPopupChoices = cell(nVars, 1);  % stores the options for popup-variables
    vTxtDescription = cell(nVars, 1);

    vVisible = true(nVars, 1);    
    vChildVariables = cell(nVars, 1);
    vParentVariables = cell(nVars, 1);    
                         
    
    for var_Id = 1:nVars 
        V = variableList{var_Id};
        valueRange = V{2};
        
        if iscell(valueRange)
            testValue = valueRange{1}(1);
        else
            testValue = valueRange(1);
        end                
        haveInitVal       = (length(V) >= 3) && ~isempty(V{3});
        haveDependentVars = (length(V) >= 4) && ~isempty(V{4});
        haveDescription   = (length(V) >= 5) && ~isempty(V{5});
        if haveInitVal
            initVal = V{3};
        end
        if haveDescription
            varDescrip = V{5};
        end
        
        % Parse input if is numeric (scalar or vector)
        if isnumeric(testValue)
            varTypes{var_Id} = 'slider';
            vIsVector(var_Id) = isamatrix(valueRange) || iscell(valueRange);
            if isamatrix(valueRange)
                vNumElements(var_Id) = size(valueRange,1);
                valueRange = mat2cell(valueRange, ones(vNumElements(var_Id),1),  size(valueRange,2) );
            elseif iscell(valueRange)
                vNumElements(var_Id) = length(valueRange);
            end

            if vIsVector(var_Id)
                vIsConst{var_Id} = cellfun(@(x) length(x) == 1, valueRange);            
            else
                vIsConst{var_Id} = (length(valueRange) == 1);            
            end            
                        
            if haveInitVal   % has given starting value;
                if vIsVector(var_Id) && (length(initVal) ~= length(valueRange))
                    error('If you provide an initial-value vector, it must have the correct number of elements')
                end                
                varValues{var_Id} = initVal;
            else
                varValues{var_Id} = valueRange(1);
            end
            setNumericVariableRange(var_Id, [1:vNumElements(var_Id)]', valueRange, varValues{var_Id});
            
            
        % Parse input if is a string-array
        elseif ischar(testValue) && iscellstr(valueRange)  % (cell array of strings)
            varTypes{var_Id} = 'popup';
            vPopupChoices{var_Id} = valueRange;
            if isamatrix(valueRange)
                error('Can only have a single list of options for popup variables');
            end
            if length(unique(valueRange)) < length(valueRange)
                error('Duplicate options found for variable "%s"', varNames{var_Id})
            end                
            vIsConst{var_Id} = (length(valueRange) == 1);
            if haveInitVal % has given starting value;
                initVal_id = find(strcmp(initVal, valueRange));
                if isempty(initVal_id)
                    if ischar(initVal)
                        error(['"' initVal '" (the given starting value) is not one of the available options of ' varNames{var_Id}]);
                    else
                        error(['The given starting value for variable ' varNames{var_Id} '(" ' var2str(initVal) ' ") is not valid.']);
                    end
                end
            else
                initVal_id = 1;
            end
            varValues{var_Id} = initVal_id;
            
        % Parse input if is a boolean (logical) type
        elseif islogical(testValue)
            varTypes{var_Id} = 'checkbox';            
            
            vIsVector(var_Id) = isamatrix(valueRange) || iscell(valueRange);
            if isamatrix(valueRange)
                vNumElements(var_Id) = size(valueRange,1);
                valueRange = mat2cell(valueRange, ones(vNumElements(var_Id),1),  size(valueRange,2) );
            elseif iscell(valueRange)
                vNumElements(var_Id) = length(valueRange);
            end
            
            if vIsVector(var_Id)
                vIsConst{var_Id} = cellfun(@(x) length(x) == 1, valueRange);            
            else
                vIsConst{var_Id} = (length(valueRange) == 1);            
            end
            
            if haveInitVal   % has given starting value;
                if vIsVector(var_Id) && (length(initVal) ~= length(valueRange))
                    error('If you provide an initial-value vector, it must have the correct number of elements')
                end      
                varValues{var_Id} = logical(initVal);
            else                
                if vIsVector(var_Id)
                    varValues{var_Id} = cellfun(@(x) x(1), valueRange);
                else
                    varValues{var_Id} = valueRange(1);
                end
            end
            
            if haveDescription  % Description of checkbox variable
                if (vNumElements(var_Id) == 1) && (length(varDescrip) == 1) && ~iscellstr(varDescrip) && iscellstr(varDescrip{1})
                    varDescrip = varDescrip{1};
                end                
                vTxtDescription{var_Id} = varDescrip; 
            end
            
        else
            error('Value range is not formatted properly');
            
        end

        if haveDependentVars
            if ~any(strcmp(varTypes{var_Id}, {'popup', 'checkbox'}) )  % only these types of variables can have a list of associated context-dependent variables
                error('You can only specify context-dependent variables for string-list or boolean arguments')
            end
            
            allVarLists = V{4};
            if ~iscell(allVarLists) || ~(nLevelCellStr(allVarLists) > 0)
                error('Context-dependent Variable List must be a (possibly nested) cell array with strings');
            end                                 
            if (vNumElements(var_Id) == 1) % for scalar checkboxes / popup boxes - put into cell array                
                if nLevelCellStr(allVarLists) < 2
                    allVarLists = {allVarLists};
                end
                if nLevelCellStr(valueRange) < 2
                    allValueRanges = {valueRange};
                else 
                    allValueRanges = valueRange;
                end                
            elseif (vNumElements(var_Id) > 1)
                if nLevelCellStr(allVarLists) < 2
                	error('Variable lists must be cell array of cell-string-arrays');
                end
                allValueRanges = valueRange;
                if ischar(testValue) && nLevelCellStr(valueRange) < 2
                	error('Value ranges for pop-up boxes must be cell array of cell-string-arrays');
                end                
            end
            
            vChildVariables{var_Id} = cell(1, vNumElements(var_Id));
            if length(allVarLists) ~= vNumElements(var_Id)
                error('You provided only %d lists of context-dependent variables for variable "%s", but there are %d variables.', length(allVarLists), varNames{var_Id}, vNumElements(var_Id));
                
            end
            for e_i = 1:vNumElements(var_Id)                
                varLists = allVarLists{e_i};
                if isempty(varLists)
                    continue;
                end
                elValueRange = allValueRanges{e_i};
                if ischar(elValueRange)
                    elValueRange = {elValueRange};
                end
                vChildVariables{var_Id}{e_i} = cell(1, length(varLists));  % note: three nested cell layers (!)

                nInList = length(varLists);
                nInRange = length(elValueRange); 
                % ok if (nInList ~= nInRange) only if: checkbox, and nInList = 1, and nInRange = 2  
                
                if (nInList ~= nInRange) 
                    error('Array of context-dependent variable for element %d of variable "%s" must have %d entries (but it has %d)', e_i, varNames{var_Id}, nInRange, nInList);
                end
                
                for list_i = 1:length(varLists)
                    list_choice_i = varLists{list_i};
                    if ~iscellstr(list_choice_i)
                        error('Argument #%d of context-dependent variable list for variable "%s" must be a cell array of strings (not of type %s)', list_i, varNames{var_Id}, class(list_choice_i))
                    end                        
                    varIdList = zeros(1, length(list_choice_i));
                    for k = 1:length(list_choice_i)
                        id_child = find( strcmp( list_choice_i{k}, varNames) );
                        if isempty(id_child)
                            error(['Unknown variable ' list_choice_i{k} ' listed as dependent variable for "' varNames{var_Id} '"']);
                        end
                        varIdList(k) = id_child;
                        vParentVariables{id_child} = unique([vParentVariables{id_child}; var_Id e_i], 'rows');
                    end
                    vChildVariables{var_Id}{e_i}{list_i} = varIdList;
                end              
                
            end
        end
        
                                    
    end
    checkVisibility(1:nVars)
    

        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% Set up Control Panel  %%%%%%%%%%%%%%%%%%%%%%%%
    
    if isempty(figId)
        figId = figure;
    else
        figure(figId); 
    end
    clf;
    if ~isempty(figureTitle)
        set(figId, 'Name', figureTitle, 'NumberTitle', 'off');        
    end
    
    height = 20;
    LB = [25, 20];
    LBpanel = [5, 5];
    label_w_max = 50;

    labelSizeMax = max(getStringWidths(varNames));
    label_w = max(labelSizeMax, label_w_max);
%     slider_w = 100;
    slider_w = 200;
    box_w = 50;    
    panelItemProps = [2 2 3 2];
%     button_w = 70;
    spacing = 2;    
    var_w   = slider_w + box_w + spacing;
    panel_w = label_w + spacing + var_w;
    nPanelItems = 4;%length(panelItemProps);
    
    panelItemSpacing = 10;
    panelItem_ws = (panel_w - panelItemSpacing*(nPanelItems+1)) * panelItemProps/sum(panelItemProps);
    autoUpdating = true;
    vValHandles = cell(nVars, 1);
    vNameHandles = cell(nVars, 1);
    gHandles = cell(nVars, 1);
    
%     vInds = find(~vIsConst);
    vInds = find(~cellfun(@all, vIsConst));
    nVars = length(vInds);

    ypos = @(y) (height+spacing)*(nVars-y);
    pos_label  = @(y) LB + [0,                          ypos(y)];
    pos_main   = @(y) LB + [label_w+2*spacing,          ypos(y)];
    pos_box    = @(y) LB + [label_w+slider_w+3*spacing, ypos(y)];
    pos_GrpTog = @(y) LB + [-LB(1) + 2,               1+ypos(y)];
   
    hControlPanel = uipanel('Parent', figId, 'Units', 'pixels', 'position', [pos_label(0), label_w + slider_w + box_w + spacing*3, height*2.8]);
    
    uicontrol('Parent', hControlPanel, 'Style','pushbutton', 'String', 'Load', ...
             'Position', [LBpanel + [0                     + panelItemSpacing*1, 0], panelItem_ws(1), 2*height], 'HorizontalAlignment', 'Center', ...
             'Callback', @loadButton_Callback);
    uicontrol('Parent', hControlPanel, 'Style','pushbutton', 'String', 'Save', ...
             'Position', [LBpanel + [sum(panelItem_ws(1))  + panelItemSpacing*2, 0], panelItem_ws(2), 2*height], 'HorizontalAlignment', 'Center', ...
             'Callback', @saveButton_Callback);
    hAuto = uicontrol('Parent', hControlPanel, 'Style','checkbox', 'String', 'Autoupdate:on', 'Value', 1, ...
             'Position', [LBpanel + [sum(panelItem_ws(1:2)) + panelItemSpacing*3, height], panelItem_ws(3), 1*height], 'HorizontalAlignment', 'Center', ...
             'Callback', @autoUpdateCheckBox_Callback);
    hUpdate = uicontrol('Parent', hControlPanel, 'Style','togglebutton', 'String', 'Update', ...
             'Position', [LBpanel + [sum(panelItem_ws(1:2)) + panelItemSpacing*3, 0], panelItem_ws(3), 1*height], 'HorizontalAlignment', 'Center', ...
             'Callback', @updateButton_Callback, 'Enable', 'off');
    hStatus = uicontrol('Parent', hControlPanel, 'Style','text', 'String', 'Ready', 'BackgroundColor', .9 * ones(1,3), ...
             'Position', [LBpanel + [sum(panelItem_ws(1:3)) + panelItemSpacing*4, .7*height], panelItem_ws(4), .8*height], 'HorizontalAlignment', 'Center');

    % context-dependent menus (for adjusting ranges).
    hcmenu_scalar_only = uicontextmenu('Parent', figId);
    hcmenu_vector_scalar = uicontextmenu('Parent', figId);
    uimenu(hcmenu_scalar_only, 'Label', 'Adjust range of variable',      'Callback', @adjustNumericScalarVariableRange_fromContextMenu);
    uimenu(hcmenu_vector_scalar, 'Label', 'Adjust range of this element', 'Callback', @adjustNumericScalarVariableRange_fromContextMenu);
%     uimenu(hcmenu_vector_scalar, 'Label', 'Adjust range of all elements', 'Callback', @adjustNumericVectorVariableRange);
    
    
         
    for var_idx = 1:length(vInds)  % idx goes from 1 to #vars being used
        var_id = vInds(var_idx);   % id is the index of the variable
        
        vNameHandles{var_id}(1) = uicontrol('Style','text',  'String', varNames{var_id}, ...
             'Units', 'Pixels', 'Position', [pos_label(var_idx), label_w, height], 'HorizontalAlignment', 'Center', 'Parent', figId);
         
        if vIsVector(var_id)  % possible for sliders & checkboxes
            pos_0 = pos_main(var_idx);
            varElPos = cell(vNumElements(var_id), 3); % starting position
            
            maxElement_w = (var_w-spacing*(vNumElements(var_id)-1)) / vNumElements(var_id);

            vElText = vTxtDescription{var_id};
            if isempty(vElText)
                vElText = cellfun(@(i) num2str(i), num2cell(1:vNumElements(var_id)), 'un', 0);
            end        
            vElText = cellfun(@(s) [s ':'], vElText, 'un', 0);
%             textWidths = getStringWidths(vElText);
            
            el_ctrl_w = 18;  % width of checkbox / slider
            
            if strcmp(varTypes{var_id}, 'slider')
                el_box_w = box_w / 2;
%                 spc = spacing*2;
            elseif strcmp(varTypes{var_id}, 'checkbox')
                el_box_w = 0;  
%                 spc = spacing*2;
            end
            ideal_el_descrip_w = floor(maxElement_w-el_ctrl_w-el_box_w);
            
%             if all(textWidths < ideal_el_descrip_w)
                el_descrip_w(1:vNumElements(var_id)) = ideal_el_descrip_w;
%             else
%                 el_descrip_w = textWidths;   % future implementation: if need more space, make
%                 size of each label dependent on how long each label needs to be.
%             end
            rightEdge = pos_0(1)+var_w;
            for e_i = 1:vNumElements(var_id)
                LB_e = [pos_0(1)+(e_i-1)*maxElement_w    , pos_0(2)];
                varElPos{e_i,1} = [LB_e(1) + spacing*(e_i-1)                     , LB_e(2), el_descrip_w(e_i), height];
                varElPos{e_i,2} = [LB_e(1) + el_descrip_w(e_i) + spacing*(e_i-1) , LB_e(2), el_ctrl_w , height];
                varElPos{e_i,3} = [LB_e(1) + el_descrip_w(e_i) + el_ctrl_w + spacing*(e_i-1), LB_e(2), el_box_w, height];
                if e_i == vNumElements(var_id)
                    if strcmp(varTypes{var_id}, 'slider')
                        varElPos{e_i,3}(3) = rightEdge - varElPos{e_i,3}(1);  % make all right edges line up exactly.
                    elseif strcmp(varTypes{var_id}, 'checkbox')
                        varElPos{e_i,2}(3) = rightEdge - varElPos{e_i,2}(1);  % make all right edges line up exactly.
                    end                    
                end
            end
            
            
        end
         
         
        switch varTypes{var_id}
            case 'slider'
                if vIsVector(var_id)
                    for e_i = 1:vNumElements(var_id)
                        
                        if ~vUniform{var_id}(e_i)
                            3;
                        end
                        smallStep = vStep{var_id}(e_i)/(vMax{var_id}(e_i)-vMin{var_id}(e_i)+eps);
                        if vUniform{var_id}(e_i)
                            sliderVal = varValues{var_id}(e_i);
                        else
                            sliderVal = vNUcurIdx{var_id}(e_i);
                        end
                        vNameHandles{var_id}(1+e_i) = uicontrol('Style','text', 'String', vElText{e_i}, ...
                            'Units', 'Pixels', 'Position', varElPos{e_i,1}, 'UserData', [var_id, e_i], 'HorizontalAlignment', 'Center', 'Parent', figId, 'uicontextmenu', hcmenu_vector_scalar);                        
                        vValHandles{var_id}(e_i,1)  = uicontrol('Style', 'slider', 'Min', vMin{var_id}(e_i), 'Max', vMax{var_id}(e_i), ...
                            'SliderStep', [smallStep, 10*smallStep],...
                            'Units', 'Pixels', 'Position', varElPos{e_i,2}, ...
                            'Value', sliderVal, 'UserData', [var_id, e_i], 'Callback', @sliders_Callback, 'Parent', figId, 'uicontextmenu', hcmenu_vector_scalar);                        
                        
                        vValHandles{var_id}(e_i,2) = uicontrol('Style', 'edit', 'String', num2str(varValues{var_id}(e_i), vStrFormat{var_id}{e_i}), ...
                            'Position', varElPos{e_i,3}, 'UserData', [var_id, e_i], ...
                            'Callback', @valuebox_Callback, 'Parent', figId, 'uicontextmenu', hcmenu_vector_scalar);
                    end
                else
                    if vUniform{var_id}
                        sliderVal = varValues{var_id};
                    else
                        sliderVal = vNUcurIdx{var_id};
                    end                                        
                    smallStep = vStep{var_id}/(vMax{var_id}-vMin{var_id});
                    vValHandles{var_id}(1) = uicontrol('Style', 'slider', 'Min', vMin{var_id}, 'Max', vMax{var_id}, ...
                        'SliderStep', [smallStep, 10*smallStep],...
                        'Units', 'Pixels', 'Position', [pos_main(var_idx), slider_w, height], ...
                        'Value', sliderVal, 'UserData', [var_id 1], 'Callback', @sliders_Callback, 'uicontextmenu', hcmenu_scalar_only, 'Parent', figId);
                    vValHandles{var_id}(2) = uicontrol('Style', 'edit', 'String', num2str(varValues{var_id}, vStrFormat{var_id}{1}), ...
                        'Position', [pos_box(var_idx), box_w, height], 'UserData', [var_id 1], ...
                        'Callback', @valuebox_Callback, 'uicontextmenu', hcmenu_scalar_only, 'Parent', figId);
                end
                
                
            case 'popup'
                vValHandles{var_id}(1) = uicontrol('Style', 'popupmenu', 'String', vPopupChoices{var_id}, 'Value', varValues{var_id}, ...
                        'Position', [pos_main(var_idx), var_w, height], 'UserData', [var_id 1], ...                    
                        'Callback', @popup_Callback, 'Parent', figId);            
            
            case 'checkbox'
                
                if vIsVector(var_id)                    
                    for e_i = 1:vNumElements(var_id)

                        vNameHandles{var_id}(1+e_i) = uicontrol('Style','text',  'String', vElText{e_i},  'UserData', [var_id, e_i], 'Callback', @checkbox_Callback, ...
                            'Units', 'Pixels', 'Position', varElPos{e_i,1}, 'HorizontalAlignment', 'Center', 'Parent', figId);
                        
                        vValHandles{var_id}(e_i,1) = uicontrol('Style', 'checkbox', 'String', '', 'Value', varValues{var_id}(e_i), ...
                            'Position', varElPos{e_i,2}, 'UserData', [var_id e_i], ...
                            'HorizontalAlignment', 'Center', 'Callback', @checkbox_Callback, 'Parent', figId);
                        
                    end
                else
                    vValHandles{var_id}(1) = uicontrol('Style', 'checkbox', 'String', vTxtDescription{var_id}, 'Value', varValues{var_id}, ...
                            'Position', [pos_main(var_idx), var_w, height], 'UserData', [var_id 1], ...
                            'Callback', @checkbox_Callback, 'Parent', figId);       

%                     addlistener(vValHandles{var_id}(1),'ChangedValue',@checkbox_Callback);
                end
                            
                
        end
    
    end
    % show collapsible groupings
    3;
    x1 = LB(1)/3; x2 = LB(1);
    
    for group_i = 1:nGroups
        v1 = gVarIds{group_i}(1);
        n = length(gVarIds{group_i});
%         P = ;
        ypos_line = @(y) LB(2)+ ypos(gVarIds{group_i}(y))+height/2;
        gHandles{group_i}(1) = uicontrol('style', 'togglebutton', 'Position', [pos_GrpTog(v1), 18, 18], 'CallBack', @groupVisibility_Toggle, ...
            'String', '-', 'fontSize', 12, 'fontName', 'Courier', 'Userdata', group_i, 'Value', 1, 'backgroundColor', [.8 .8 .8], 'Parent', figId);
        gHandles{group_i}(2) = annotation(figId, 'line', [0 0], [0 0], 'units', 'pixels');
        set(gHandles{group_i}(2), 'x', [x1;x1], 'y', ypos_line([1;n]), 'LineStyle', ':');
        for vi = 1:n
            gHandles{group_i}(2+vi) = annotation(figId, 'line', [0 0], [0 0], 'units', 'pixels');
            set(gHandles{group_i}(2+vi), 'x', [x1;x2], 'y', repmat(ypos_line(vi), 2,1), 'LineStyle', ':' );
        end              
    end
    
    
    updateControlsVisibility;       
        
    callUpdateFunction_hnd  = @callUpdateFunction;  % for 'manipulateSetValue' function
    callUpdateRanges_hnd    = @callUpdateRanges;    % for 'manipulateSetRange' function
    vHandles = struct('varNames', {varNames}, 'varTypes', {varTypes}, 'vMin', {vMin}, 'vMax', {vMax}, 'vPopupChoices', {vPopupChoices}, ...
        'vHandles', {vValHandles}, 'callUpdateFunction', callUpdateFunction_hnd, 'callUpdateRanges', callUpdateRanges_hnd);    
    if initialCall
        callUpdateFunction;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%% CALLBACK FUNCTIONS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% sliders & valuebox pairs
    function sliders_Callback(hObject, ~, wait_flag) 
        id = get(hObject,'UserData');
        varId = id(1); 
        elId =  id(2);
        newValue = get(hObject, 'Value');
        
        if ~vUniform{varId}(elId)
            newValue = vNUvals{varId}{elId}(round(newValue));
        end
        if nargin < 3
            wait_flag = 0;
        end
        
        setVariable(varId, elId, newValue, wait_flag);
    end

    function valuebox_Callback(hObject, eventdata, handles) %#ok<INUSD>
        id = get(hObject,'UserData');
        varId = id(1); 
        elId =  id(2);
        newValue = str2double(get(hObject,'String'));

        setVariable(varId, elId, newValue);                    
    end

    %%% Popup-menus
    function popup_Callback(hObject, eventdata, handles)  %#ok<INUSD>
        id = get(hObject,'UserData');
        varId = id(1); 
        elId =  id(2);
        newValue = get(hObject,'Value');
        
        setVariable(varId, elId, newValue);
    end
    
    %%% Checkboxes
    function checkbox_Callback(hObject, eventdata, handles) %#ok<INUSD>
        id = get(hObject,'UserData');
        varId = id(1); 
        elId =  id(2);
        
        newValueId = logical( get(hObject,'Value') );
        
        setVariable(varId, elId, newValueId);
    end

    
    function groupVisibility_Toggle(hObject, eventdata, handles) %#ok<INUSD>
        groupId = get(hObject, 'UserData');
        show_tf = get(hObject, 'Value');
        
        vGroupVisible(groupId) = show_tf;
        checkVisibility(gVarIds{groupId});
        if show_tf
            set(hObject, 'String', '-')
        else
            set(hObject, 'String', '+')
        end
        updateControlsVisibility;
        
    end



    %%% Load Button
    function loadButton_Callback(hObject, eventdata, handles) %#ok<INUSD>
        [filename, pathname] = uigetfile({'*.mat';'*.*'}, 'Select File to Load', defaultSaveName);
        if (filename == 0)
            return;
        end
        S = load([pathname filename]);
        defaultSaveName = filename;
        
        loadedVarNames = S.savedVarNames;
        loadedVarValues = S.savedVarValues;
        for loaded_var_i = 1:length(loadedVarNames)
            varId = find(strcmp(loadedVarNames{loaded_var_i}, varNames));
            val = loadedVarValues{loaded_var_i};
            if ~isempty(varId)
                if strcmp(varTypes{varId}, 'popup')
                    val = find(strcmp(val, vPopupChoices{varId}));
                end
                if ~isempty(val)     
                    setVariable(varId, elId, val, 1);
                end
            end
        end
        checkVisibility(1:nVars);
        
        updateControlsVisibility;
        updateControlsValues;
        callUpdateFunction;
    end

    %%% Save Button
    function saveButton_Callback(hObject, eventdata, handles) %#ok<INUSD>
        savedVarNames = varNames;              %#ok<NASGU>
        savedVarValues = varValues;                 
        popupVals = find(strcmp('popup', varTypes));
        for v_id = popupVals(:)'
            savedVarValues{v_id} = vPopupChoices{v_id}(varValues{v_id});
        end
        
        [fileName,pathName] = uiputfile({'*.mat';'*.*'},'Save File as',figureTitle);
        if (fileName == 0)
            return;
        end
        save([pathName fileName], 'savedVarNames', 'savedVarValues')
        defaultSaveName = fileName;
    end

    function autoUpdateCheckBox_Callback(hObject, eventdata, handles) %#ok<INUSD>
        onOff = get(hObject, 'value');
        if (onOff == 0);  % do not update automatically
            set(hUpdate, 'Enable', 'on');
            set(hAuto, 'String', 'Autoupdate:off');
            autoUpdating = false;
        elseif (onOff == 1)  % update automatically
%             set(hUpdate, 'Enable', 'on');
            set(hUpdate, 'Enable', 'off');
            set(hAuto, 'String', 'Autoupdate:on');
            autoUpdating = true;
            callUpdateFunction;
        end
        
    end

    function updateButton_Callback(hObject, eventdata, handles) %#ok<INUSD>
        callUpdateFunction;        
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% HELPER FUNCTIONS

    function checkVisibility(varIds)
                       
        for varId = varIds(:)'   %#ok<FXUP>   % First, check which variables are needed.
            if all( vIsConst{varId} )
                vVisible(varId) = false;
                continue;
            end
            
%             for e_i = 1:vNumElements(varId)
            parentIds = vParentVariables{varId};
            visible = isempty(parentIds) ;   % if has no parent variables, then it should be visible by default.
            for parId = parentIds'           % if has parent variables, then check if those parents current setting requires that they be visible.
                pVarId = parId(1); pElId = parId(2);
                if strcmp(varTypes{pVarId}, 'checkbox')
                    parIchildren = vChildVariables{pVarId}{pElId}{ 1+varValues{ pVarId }(pElId) };  % "false"-> 1, "true"->2
                elseif strcmp(varTypes{pVarId}, 'popup')
                    parIchildren = vChildVariables{pVarId}{pElId}{ varValues{ pVarId }(pElId) };    % use which item is selected
                end
                if any(parIchildren == varId)
                    visible = true;
                    break;
                end            
            end
            vVisible(varId) = visible;        
        end
        
        if (nGroups > 0)     % Then, make variables of all collapsed groups invisible, except for one, if active
            groupsAffected = setdiff( unique(vGroup(varIds)), 0);
            for grpId = groupsAffected(:)'  %
                groupVarIds = gVarIds{grpId};
                varsNeeded  = groupVarIds(vVisible(groupVarIds));
                if ~vGroupVisible(grpId) && (~isempty(varsNeeded))
                   vVisible(groupVarIds) = false;
                   vVisible(varsNeeded(1)) = true;
                end
            end
        end    
           
    end


    function updateControlsVisibility
        
        vValHandlesRows = vValHandles;
        vValHandlesRows = cellfun(@(x) x(:)', vValHandlesRows, 'un', 0);
        
        set([vNameHandles{~vVisible}, vValHandlesRows{~vVisible}], 'Visible', 'off');
        set([vNameHandles{vVisible}, vValHandlesRows{vVisible}], 'Visible', 'on');

        for v_id = find(vVisible & (vNumElements > 1))'
%             if ~all( vIsConst{v_id} ) && any( vIsConst{v_id} )  % ie. if some (but not all) elements are inactive                
                set(vValHandles{v_id}( vIsConst{v_id}, : ), 'Enable', 'off')
                set(vValHandles{v_id}( ~vIsConst{v_id}, : ), 'Enable', 'on')
%             end            
        end
        
        vInds = find(vVisible);
        nVarsShow = length(vInds);
        ypos     = @(y) LB(2) + (height+spacing)*(nVarsShow-y);
        ypos_mid = @(y) ypos(y)+height/2;
        
        varY = zeros(1,nVars);
        varY(vInds) = 1:length(vInds);
        % Move control panel into new position
        modifyYposition(hControlPanel, ypos(0));
        
        % Move individual variable controls into new positions
        for v_id = vInds'
            modifyYposition([vNameHandles{v_id}, vValHandlesRows{v_id}], ypos(varY(v_id)))
        end
        
        % Move group visibility controls into new positions        
        if nGroups > 0            
            pos_GrpTog = @(y) [2, 1+ypos(y)];

            for grp_i = 1:nGroups
%                 v1 = gVarIds{grp_i}(1);

                grp_inds = find(vVisible(gVarIds{grp_i}));
                var_inds = gVarIds{grp_i}(grp_inds);
                set(gHandles{grp_i}, 'Visible', 'off')
                if ~isempty(var_inds)
                    set(gHandles{grp_i}([1;2; 2+grp_inds]), 'Visible', 'on');
                    set(gHandles{grp_i}(1), 'Position', [pos_GrpTog(varY( var_inds(1))), 18, 18]);
                    %                 modifyYposition(gHandles{grp_i}(2), ypos_mid(varY(v_id)));
                    set(gHandles{grp_i}(2), 'y', ypos_mid(varY([var_inds([1,end])])));
                    for gv_i = 1:length(grp_inds)
                        modifyYposition(gHandles{grp_i}(2+grp_inds(gv_i)), ypos_mid(varY(var_inds(gv_i))));
                    end
                end
            end
        end
    end

      % If a value is changed :
    function updateControlsValues  % (eg after loading)
        for var_j = 1:nVars  %update variables            
            if all(vIsConst{var_j})
                continue;  % ?why? still need to set variable?
            end
            val = varValues{var_j};            
            set(vValHandles{var_j}(1), 'Value', val)
            if strcmp(varTypes{var_j}, 'slider')
                set(vValHandles{var_j}(2), 'Value', val, 'String', num2str(val, vStrFormat{var_j}));
            end
%             elseif (varTypes{var_j} == POPUP)
%                 valId = find(strcmp(val, vPopupChoices{var_j}));
%                 set(vValHandles{var_j}(1), 'Value', valId);                            
%             elseif (varTypes{var_j} == 'checkbox')                
%                 set(vValHandles{var_j}(1), 'Value', val);
%             end            
        end
    end

    function callUpdateFunction
        set(hStatus, 'String', 'Working...'); drawnow;        

        valuesToPass = varValues;        
        for popupId = find(strcmp('popup', varTypes))'  % change popup menu items from id -> string value
            valuesToPass{popupId} = vPopupChoices{popupId}{varValues{popupId}};
        end
        
        if groupAllArgsIntoCell
            updateFuncHandle(valuesToPass);
        else
            updateFuncHandle(valuesToPass{:});
        end

        set(hStatus, 'String', 'Ready');
    end
    
    function setVariable(varId, elId, newValue, waitFlag)
        updateNow = ~exist('waitFlag', 'var') || (waitFlag ~= 1);        
        
        switch varTypes{varId}
            case 'slider'
                oldValue = varValues{varId}(elId);
                
                if vUniform{varId}(elId)
                    newValue = roundTo(newValue, vStep{varId}(elId));
                    if newValue < vMin{varId}(elId)
                        newValue = vMin{varId}(elId);
                    elseif newValue > vMax{varId}(elId)
                        newValue = vMax{varId}(elId);
                    end                    
                    newSliderValue = newValue;
                else                    
                    % in case set value using value-box, must make sure now that is one of allowed values.
                    newIdx = indmin( abs(newValue-vNUvals{varId}{elId}) );                                        
                    newValue = vNUvals{varId}{elId}(newIdx);                        
                    vNUcurIdx{varId}(elId) = newIdx;
                    newSliderValue = newIdx;                    
                end
                
                if updateNow
                    set(vValHandles{varId}(elId,1), 'Value', newSliderValue)  % slider value
                    set(vValHandles{varId}(elId,2), 'Value', newValue, 'String', num2str(newValue, vStrFormat{varId}{elId})); % box value
                end
            
            
            case 'popup'
                assert(elId == 1);
                oldValue = varValues{varId};
                varValues{varId} = newValue;
%                 if ~ibetween(newValue, 0, length(vPopupChoices{varId})) % if loaded value from obsolete file.
%                     newValueId = oldValueId;
                if updateNow
                    set(vValHandles{varId}(1), 'Value', newValue);
                end
                        
            case 'checkbox'
                oldValue = varValues{varId}(elId);
                if updateNow
                    set(vValHandles{varId}(elId), 'Value', newValue);
                end
        end
        
        varValues{varId}(elId) = newValue; % must do this before showing/hiding context-dependent varibales - their visibility might depend on the new value;
        
        vChildVars = vChildVariables{varId};
        if ~isempty(vChildVars) && iscell(vChildVars)
            vChildVars = vChildVars{elId};
        end
        if ~isempty(vChildVars) % if are context-dependent variables, make them in/visible.
            % make (ir)relevant variables (in)visible
            if strcmp(varTypes{varId}, 'checkbox'), 
                offset = 1;
            else
                offset = 0;
            end
            hideVarIds = vChildVars{offset+oldValue};
            showVarIds = vChildVars{offset+newValue};
            checkVisibility([hideVarIds(:); showVarIds(:)]);

            if updateNow
                updateControlsVisibility;
            end
        end            
        
        if (~exist('waitFlag', 'var') || (waitFlag ~= WAIT)) && autoUpdating            
            set(hStatus, 'String', 'Working...'); drawnow;
            callUpdateFunction; 
            set(hStatus, 'String', 'Ready');
        end
                
    end


    function adjustNumericVectorVariableRange(hObject, eventdata, handles) 
        id = get(gco,'UserData');
        varId = id(1); 
        elId =  id(2);
        
        curMins = vMin{varId};
        curMaxs = vMax{varId};
        curStepSizes = vStep{varId};
        curVals = varValues{varId};
        curNsteps = (curMaxs-curMins)./curStepSize;
        varName = varNames{varId};
        dlgTitle = ['Enter new range for ' varName];
        prompt = {['(' varName '): Min:'], 'Max:', '[Change either Step size OR Num steps]\nstep size:', 'Num steps)'};
        def = {curMin, curMax, curStepSize, curNsteps};
        C_str = dialog(prompt, dlgTitle, 1, cellfun(@num2str, def, 'Un', false));
        
        
        
        
        C = arrayfun(@str2double, C_str);
        if ~isempty(C) 
            [newMin, newMax, newStepSize, newNsteps] = elements(C);
            if newMax < newMin
                errordlg('Max must be >= Min ','Adjust range');
            end
            
            if (newNsteps ~= curNsteps) % user changed number of steps:
                newRange = linspace(newMin, newMax, newStepSize);
%                 newStepSize = diff(newRange(1:2));                
            elseif (newStepSize ~= curStepSize)   % user changed step size:
                newRange = [newMin:newStepSize:newMax];
                %newNsteps = length(newRange);
            end
            
            setNumericVariableRange(varId, elId, newRange);            
            smallStep = vStep{var_id}(elId)/(vMax{var_id}(elId)-vMin{var_id}(elId));
            set(vValHandles{var_id}(1,elId), 'Min', newMin, 'Max', newMax,  'SliderStep', [smallStep, 10*smallStep])
            setVariable(varId, elId, curVal);
        end
        
        
    end

    function adjustNumericScalarVariableRange_fromContextMenu(hObject, eventdata, handles) %#ok<INUSD>
        id = get(gco,'UserData');
        varID = id(1); 
        elID = id(2);
                
        curMin = vMin{varID}(elID);
        curMax = vMax{varID}(elID);
        curStepSize = vStep{varID}(elID);
        curVal = varValues{varID}(elID);
        curNsteps = (curMax-curMin)/curStepSize;
        varName = varNames{varID};
                
        newParams = adjustVariableDialog(curMin, curMax, curStepSize, curNsteps, varName);
        
        if ~isempty(newParams) 
            [newMin, newMax, newStepSize, newNsteps] = elements(newParams);
            if newMax < newMin
                errordlg('Max must be >= Min ','Adjust range');
            end
            newRange = [newMin:newStepSize:newMax];
            vUniform{varID}(elID) = true;
            
            setNumericVariableRange(varID, elID, newRange, varValues{varID}(elID));            
            smallStep = vStep{varID}(elID)/(vMax{varID}(elID)-vMin{varID}(elID));
            set(vValHandles{varID}(elID, 1), 'Min', newMin, 'Max', newMax,  'SliderStep', [smallStep, 10*smallStep])
            setVariable(varID, elID, curVal);
        end
        
    end

    function adjustNumericScalarVariableRange_fromScript(varID, elID, newRange) 
                                        
        newMin = min(newRange);
        newMax = max(newRange);
        if isempty(newRange)
            error('Range is empty');
        end                
                        
        setNumericVariableRange(varID, elID, newRange, varValues{varID}(elID));            
        smallStep = vStep{varID}(elID)/(vMax{varID}(elID)-vMin{varID}(elID));
        set(vValHandles{varID}(elID, 1), 'Min', newMin, 'Max', newMax,  'SliderStep', [smallStep, 10*smallStep])
        setVariable(varID, elID, curVal);
        
    end



    function setNumericVariableRange(var_Id, el_Id, valueRange, val0)
        
        if iscell(valueRange)
            cellfun(@(e_id,rng) setNumericVariableRange(var_Id, e_id, rng), num2cell(el_Id), valueRange)
            return;
        end
        
        vIsConst{var_Id}(el_Id) = (valueRange(1) == valueRange(end));
        vUniform{var_Id}(el_Id) = true;
        
        vMin{var_Id}(el_Id) = valueRange(1);
        vMax{var_Id}(el_Id) = valueRange(end) + 1e-10; % so that slider will still render if min = max.
        
%         if (vMax{var_Id}(el_Id) <= vMin{var_Id}(el_Id))
%             vIsConst{var_Id}(el_Id) = true;
% %             error(['Max must be greater than Min for variable "' varNames{var_Id} '".']);
%         end        
        
        vStep{var_Id}(el_Id) = 0;
               
        if length(valueRange) > 1
            dsteps = abs(diff(valueRange, 2));
            vUniform{var_Id}(el_Id) = ~any(dsteps > 1e-5);
            if vUniform{var_Id}(el_Id)
                vStep{var_Id}(el_Id) = roundTo(median(diff(valueRange)), 1e-5);
            else
%                 vNUindices{var_Id}(el_Id) = [1:length(valueRange)];
                vNUvals{var_Id}{el_Id} = valueRange;
                vNUcurIdx{var_Id}(el_Id) = indmin( abs(val0-vNUvals{var_Id}{el_Id}) );
                varValues{var_Id}(el_Id) = vNUvals{var_Id}{el_Id}(vNUcurIdx{var_Id}(el_Id));
                vStep{var_Id}(el_Id) = 1;
                vMin{var_Id}(el_Id) = 1;
                vMax{var_Id}(el_Id) = length(valueRange);                
            end                
                
%         elseif length(valueRange) == 2
%             vStep{var_Id}(el_Id) = diff(valueRange([1, end]))/(nStepsDefault-1);
        elseif length(valueRange) == 1
            vIsConst{var_Id}(el_Id) = true;
%             return;
        end        
       
        if vUniform{var_Id}(el_Id)
            formatTesters = [vStep{var_Id}(el_Id), valueRange(1), valueRange(end)];            
        else
            formatTesters = [valueRange];
        end
        
        if all(mod(formatTesters, 1) == 0)
            vStrFormat{var_Id}{el_Id} = '%d';
        else
            sig = -log10(setdiff(abs(formatTesters),0));
            sig = max(ceil(sig));
            sig = max(sig, 0);
%             sig = min(sig, 3);
            vStrFormat{var_Id}{el_Id} = ['%.' num2str(sig) 'f'];
        end                    
        
    end


    function modifyYposition(h, newY)
        if length(h) == length(newY)
            for j = 1:length(h)
                P = get(h(j), 'Position');
                P(2) = newY(j);
                set(h(j), 'Position', P)
            end
        elseif (length(h) > 1) && (length(newY) == 1)
            for j = 1:length(h)
                P = get(h(j), 'Position');
                P(2) = newY;
                set(h(j), 'Position', P)
            end
    %     elseif (length(h) == 1) && (length(newY) == 1)
    % 
    % 
        end

    end

    function textWidths = getStringWidths(c_strs)
        figure(5005);
        h_txt_tmp = text('String', 'X', 'interpreter', 'none', 'fontsize', 8, 'fontname', 'MS Sans Serif');
        set(h_txt_tmp, 'units', 'pixels');
        textWidths = zeros(1,length(c_strs));
        for s_i = 1:length(c_strs)
            set(h_txt_tmp, 'String', c_strs{s_i});
            s = get(h_txt_tmp, 'Extent');
            textWidths(s_i) = s(3)+2;
        end                
        close(5005);
    end


    function callUpdateRanges()
        % called externally if ranges are adjusted from outside this function.
        
        % need to complete this.
        adjustNumericScalarVariableRange_fromScript
        
        
    end
        

end


%---------------------------------------------
function s = var2str(v)
    if isnumeric(v)
        s = num2str(v);
        return;
    end

    switch class(v)
        case 'char'
            s = ['''' v ''''];
        case 'function_handle'
            s = ['@' func2str(v)];
            s = strrep(s, '@@', '@');
        case 'logical'
            if v,
                s = 'true';
            else
                s = 'false';
            end
        case 'cell'  
            s = cellfun(@var2str, v, 'UniformOutput', false);  % recursively apply this function to each cell element
            spc = [repmat({', '}, 1, length(s)-1), {''}];
            s_spc = [s(:)'; spc];
            s = ['{' s_spc{:} '}'];    
    end
    
end



function newParams = adjustVariableDialog(curMin, curMax, curStepSize, curNumSteps, varName)

    hDlg = dialog('Name','adjustVariableRange',...
        'PaperPosition',get(0,'defaultfigurePaperPosition'),...
        'Position',[520 328 341 172],...
        'Resize','off',...
        ...'WindowStyle',get(0,'defaultfigureWindowStyle'),...
        'Visible','on');

    hOK     = uicontrol('Parent',hDlg, 'Position',[250 108 69 30], 'String','OK', 'callback', @OK_button );
    hCancel = uicontrol('Parent',hDlg, 'Position',[250 71 69 30], 'String','Cancel', 'callbac', @cancel_button );

    uicontrol('Style','text', 'String',['Adjust Range for variable : ' varName], 'Parent',hDlg, 'FontSize',11, 'Position',[78 150 190 18]);
    uicontrol('Style','text', 'String','Max', 'Parent',hDlg, 'HorizontalAlignment','right', 'Position',[0 83 70 20] );
    uicontrol('Style','text', 'String','Min', 'Parent',hDlg, 'HorizontalAlignment','right', 'Position',[0 115 70 20]);
    uicontrol('Style','text', 'String','Step size', 'Parent',hDlg, 'HorizontalAlignment','right', 'Position',[0 51 70 20]);
    uicontrol('Style','text', 'String','Num Steps', 'Parent',hDlg, 'HorizontalAlignment','right', 'Position',[0 17 70 20]);


    hMinField = uicontrol('Style','edit', 'String', num2str(curMin), 'Parent',hDlg, 'Position',[85 119 100 20], 'BackgroundColor',[1 1 1], 'Callback', @updateSteps_Callback);
    hMaxField = uicontrol('Style','edit', 'String', num2str(curMax), 'Parent',hDlg, 'Position',[85 87 100 20], 'BackgroundColor',[1 1 1], 'Tag','max', 'Callback', @updateSteps_Callback);
    hStepSizeField = uicontrol('Style','edit', 'String', num2str(curStepSize), 'Parent',hDlg, 'Position',[85 55 100 20], 'BackgroundColor',[1 1 1], 'Tag','stepSize', 'Callback', @updateSteps_Callback);
    hNumStepsField = uicontrol('Style','edit', 'String', num2str(curNumSteps), 'Parent',hDlg, 'Position',[85 21 100 20], 'BackgroundColor',[1 1 1], 'Tag','numSteps', 'Callback', @updateSteps_Callback);
    hSlider = uicontrol('Style','slider', 'Parent',hDlg, 'Position',[186 21 18 19], 'BackgroundColor',[1 1 1], 'Value', curNumSteps, 'Min', 0, 'Max', curNumSteps*2, 'sliderstep', 1/(2*curNumSteps)*[1, 1], 'Tag', 'numStepsSlider', 'Callback', @updateSteps_Callback);

    function OK_button(obj, evd)
        set(hDlg,'UserData','OK');
        uiresume(gcbf);
    end

    function cancel_button(obj, evd)
        delete(gcbf);
    end
            
    function updateSteps_Callback(hObject, eventdata, handles) 
        newMin = str2double(get(hMinField, 'string'));
        newMax = str2double(get(hMaxField, 'string'));
        
        if strncmp(get(gcbo, 'Tag'), 'numSteps', 7)
            
            if strcmp(get(gcbo, 'Tag'), 'numStepsSlider')
                newNumSteps = round(get(hSlider, 'value'));
            else
                newNumSteps = str2double(get(hNumStepsField, 'string'));
            end
            
            newRange = linspace(newMin, newMax, newNumSteps);
            newStepSize = diff(newRange(1:2));
        else
            newStepSize = str2double(get(hStepSizeField, 'string'));
            newRange = newMin : newStepSize : newMax;
            newNumSteps = length(newRange);
        end                    
        set(hNumStepsField, 'String', num2str(newNumSteps));            
        set(hStepSizeField, 'String', num2str(newStepSize));                
%         fprintf('val: %.4f, max: %.4f,  step: %.4f, step * max: %.4f', get(hSlider, 'value'), get(hSlider, 'max'), get(hSlider, 'sliderstep')* )
        set(hSlider, 'value', newNumSteps, 'max', newNumSteps*2, 'sliderstep', 1/(2*newNumSteps)*[1, 1]);        
%         uicontrol(gcbo);
        
%         10
%         [0, 20]
%         step = 1 = (20-0)*(1/20)
    end



    updateSteps_Callback;
    
    uiwait(hDlg);
    newParams = [];

    if ishandle(hDlg)
        if strcmp(get(hDlg,'UserData'),'OK'),
            newParams = [newMin, newMax, newStepSize, newNumSteps];
        end
        delete(hDlg);
    end
    
end

function [tf, reason] = isProperInputArg(arg)

    tf = false;
    if ~iscell(arg)
        reason = 'Argument must be a cell array';
        return;
    end
    if (length(arg) < 2)
        reason = 'Argument must be have at least 2 elements';
        return;
    end
    if (length(arg) > 5)
        reason = 'Argument must be have at most 5 elements';
        return;
    end
    if ~ischar(arg{1}) || isempty(arg{1}) 
        reason = 'First element of argument must be a string (the name of the variable)';
        return;
    end
    if isempty(arg{2}) || isempty(arg{2})
        reason = 'First element of argument must be a range of values';
        return;
    end
    tf = true;
    reason = '';
end


function n = nLevelCellStr(C)
    % how many levels deep is a cell? (how many sub-levels to go until
    % find a string?                

    if ~iscell(C)            
        n = 0;
        return;
    end
    n = 1;
    while all(cellfun(@iscell, C)) && ~all(cellfun(@iscellstr, C))
        C = [C{:}];
        n = n + 1;
    end

end

function tf = isamatrix(A)
    sizeA = size(A);
    tf = (length(sizeA) == 2) && all(sizeA > 1);
end

function y = roundTo(x, s)
    y = s*round(x/s);    
end

function varargout=parseArgValuePairs(allParamNames,defaultVals,varargin)

    varargout = defaultVals;   

    % Initialize some variables
    % nparams = length(allParamNames);

    nArgs = length(varargin);

    % Must have name/value pairs
    if mod(nArgs,2)~=0
        error('Wrong number of arguments.');
    end
        
    % Process name/value pairs
    for arg_idx=1:2:nArgs
        paramName = varargin{arg_idx};
        if ~ischar(paramName)
            error('Parameter name must be text.');
        end
        param_idx = find(strcmpi(paramName,allParamNames));
        if isempty(param_idx)
            error('Invalid parameter name:  %s.',paramName);
        elseif length(param_idx)>1
            error('Parameter %s is defined multiple times', paramName);
        else
            varargout{param_idx} = varargin{arg_idx+1};
        end
    end
end




%%% VARIABLES - each user variable has the following variables associated with it: 
% varId, varNames, varValues, updateFuncHandleToUpdateWhenVarChanged, [vMin, vMax, vStep]/[vPopupChoices], vValHandles
% vVisible

%%% Functions
% varIdsForFunction 

% possible error: if first in a group is invisible


% check - lengths of inputs are ok.