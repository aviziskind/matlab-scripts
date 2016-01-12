function allTables = expandOptionsToList(allOptions, loopKeysOrder)
    
%     baseTable = {}
%     loopKeys = {}
%     loopValues = {}
%     nValuesEachLoopKey = {}
%     nTablesTotal = 1;
    if length(allOptions) > 1
        error('Input single struct')
    end
    
    loopFromFirstToLast = true;
    

    % remove tbl_values that are empty cells
    allVals_C = struct2cell(allOptions);
    isEmptyCell = cellfun(@isempty, allVals_C);
    
    fldnames = fieldnames(allOptions);
    fldnames = fldnames(~isEmptyCell);
    tf_fn_loop = strncmp(fldnames, 'tbl_', 4);
    loopKeys_full = fldnames(tf_fn_loop);
    loopKeys = cellfun(@(s) strrep(s, 'tbl_', ''), loopKeys_full, 'un', 0);
    nonLoopKeys = fldnames(~tf_fn_loop);
    
    if nargin > 1 && ~isempty(loopKeysOrder)
         %%
         idx_break = find(strcmp(loopKeysOrder, ''), 1);
         if isempty(idx_break)
             idx_break = length(loopKeysOrder)+1;
         end
         
         idx_loopKeys_setOrder_first = cellfun(@(key) find(strcmp(key, loopKeys)), loopKeysOrder(1:idx_break-1));
         if idx_break < length(loopKeysOrder)
             idx_loopKeys_setOrder_last  = cellfun(@(key) find(strcmp(key, loopKeys)), loopKeysOrder(idx_break+1:end));
         else
             idx_loopKeys_setOrder_last = [];
         end
         
         
         loopKeys_other_idxs = setdiff(1:length(loopKeys), [idx_loopKeys_setOrder_first, idx_loopKeys_setOrder_last]);
         
         idx_new_order = [idx_loopKeys_setOrder_first, loopKeys_other_idxs, idx_loopKeys_setOrder_last];
        
         loopKeys_full = loopKeys_full(idx_new_order);
         loopKeys = loopKeys(idx_new_order);

    end
        
    
%     -- find which variables are to be looped over, and gather in a separate table
    baseTable = struct;
    for fld_i = 1:length(nonLoopKeys)
        baseTable.(nonLoopKeys{fld_i}) = allOptions.(nonLoopKeys{fld_i});
    end
    
    nValuesEachLoopKey = cellfun(@(fld) length(allOptions.(fld)), loopKeys_full);
    nTablesTotal = prod(nValuesEachLoopKey);
    

%     -- initialize loop variables
    nLoopFields = length(nValuesEachLoopKey);
    loopIndices = ones(1, nLoopFields);
    
    if loopFromFirstToLast
        fieldIdxStart = 1;
        fieldInc = 1;
        fieldIdxStop = nLoopFields+1;
    else
        fieldIdxStart = nLoopFields;
        fieldInc = -1;
        fieldIdxStop = 0;
    end
    
%     -- loop over all the loop-variables, assign to table.
    if nTablesTotal == 0 
        allTables = [];
        return;
    end
%     allTables = repmat(baseTable, 1, nTablesTotal);
    for j = 1:nTablesTotal
        tbl_i = baseTable;
        
        
        for i = 1:nLoopFields
            vals_field_i = allOptions.(loopKeys_full{i});
            if ~iscell(vals_field_i)
                error('Field %s is not a cell array', loopKeys_full{i});
            end
            
            if isempty(strfind(loopKeys{i}, '_and_'))
                tbl_i.(loopKeys{i}) = vals_field_i{loopIndices(i)};
            else
                idx_flds = strfind(loopKeys{i}, '_and_');
                fld_idx_start = [1, (idx_flds+length('_and_')) ];
                fld_idx_end = [idx_flds-1, length(loopKeys{i})];
                
                for k = 1:length(fld_idx_start)
                    sub_field_i = loopKeys{i}(fld_idx_start(k):fld_idx_end(k));
                    tbl_i.(sub_field_i) = vals_field_i{loopIndices(i)}{k};
                end
            end
        end
        allTables(j) = tbl_i; %#ok<AGROW>
        
        curFldIdx = fieldIdxStart;
        loopIndices(curFldIdx) = loopIndices(curFldIdx) + 1;
        while loopIndices(curFldIdx) > nValuesEachLoopKey(curFldIdx)
            loopIndices(curFldIdx) = 1;
            curFldIdx = curFldIdx + fieldInc;
            
            if curFldIdx == fieldIdxStop
                assert(j == nTablesTotal)
                break;
            end
            loopIndices(curFldIdx) = loopIndices(curFldIdx)+1;
        end
        
    end
    


end