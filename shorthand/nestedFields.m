function fld_vals = nestedFields(S, varargin)
   
    handleMisMatchedFields = false;
    if isequal(abs(varargin{end}), 1)
        handleMisMatchedFields = true;
        if varargin{end} == 1
            misMatchedFieldsKeep = 'all';
        elseif varargin{end} == -1
            misMatchedFieldsKeep = 'intersection';
        end
        varargin = varargin(1:end-1);

    end
    if iscellstr(varargin{1});
        flds = varargin{1};
    else
        flds = varargin;
    end 
    
    fld_vals = S;
    
    
%     fld_vals = [S.(flds{1})];    
    for i = 1:length(flds)
        try
            fld_vals = [fld_vals.(flds{i})];
        catch MErr
            if strcmp(MErr.identifier, 'MATLAB:catenate:structFieldBad')
                
                whichHaveField = arrayfun(@(s) isfield(s, flds{i}), fld_vals);
                if ~all(whichHaveField)
                    error('Not all elements have the field %s (only %d / %d do)', flds{i}, nnz(whichHaveField), length(whichHaveField));
                else
                    
                    if handleMisMatchedFields
                        S = {fld_vals.(flds{i})};
                        fields_eachEntry = cellfun(@fieldnames, S, 'un', 0);
                        if strcmp(misMatchedFieldsKeep, 'all')
                            allFields = unique(cat(1, fields_eachEntry{:}));
                            for entry_i = 1:length(S)
                                missingFields_i = setdiff(allFields, fields_eachEntry{entry_i} );
                                for fld_j = 1:length(missingFields_i)
                                    S{entry_i}.(missingFields_i{fld_j}) = nan;
                                end
                            end

                        elseif strcmp(misMatchedFieldsKeep, 'intersection')
                            fields_keep = intersectAll(fields_eachEntry);
                            for entry_i = 1:length(S)
                                extraFields_i = setdiff(fields_eachEntry{entry_i}, fields_keep );
                                S{entry_i} = rmfield(S{entry_i}, extraFields_i);
                            end
                        end
                        
                        fld_vals = [S{:}];
                    else
                    
                        allFlds = arrayfun(@(s) cellstr2csslist(fieldnames(s.(flds{i})), ', '), fld_vals, 'un', 0);
                        [uFldList, fldListIndex, fldListCount] = uniqueList(allFlds);
                        if length(uFldList) > 1
                            ss{1} = sprintf('Fieldnames of "%s" are not the same for all elements: \n', flds{i}); %#ok<AGROW>
                            for j = 1:length(uFldList)
                                ss{j+1} = sprintf('%4d have the following fields : %s\n\n', fldListCount(j), uFldList{j}); %#ok<AGROW>
                            end
                            error('%s', [ss{:}]);
                        end                                                            
                    end
                end                
            else                
                rethrow(MErr)
            end
           3; 
        end
    end
end
