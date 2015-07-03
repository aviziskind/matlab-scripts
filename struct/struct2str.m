function str = struct2str(S)

    fld_names = fieldnames(S);
    Ls = cellfun(@length, fld_names);
    maxL = max(Ls);
    
    buffer = 4;
    
    strs_C = cellfun(@(fld) sprintf(['%' num2str(maxL+buffer) 's: %s\n'], fld, var2str(S.(fld))), fld_names, 'un', 0);
    str = [strs_C{:}];
    
end