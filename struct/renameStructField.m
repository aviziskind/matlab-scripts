function s2 = renameStructField(s1, oldFieldName, newFieldName)
    allFieldNames = fieldnames(s1);
    ind = find(strcmp(oldFieldName, allFieldNames), 1);
    if isempty(ind)
        error('field name not found')
    end
    c = struct2cell(s1);
    allFieldNames{ind} = newFieldName;
    s2 = cell2struct(c, allFieldNames);    

%     s.(newFieldName) = s.(oldFieldName);
%     s = rmfield(s, oldFieldName);

end