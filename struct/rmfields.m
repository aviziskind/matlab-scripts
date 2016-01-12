function S = rmfields(S, flds_to_remove, errorIfFieldMissing_flag)

    errorIfFieldMissing = exist('errorIfFieldMissing_flag', 'var') && isequal(errorIfFieldMissing_flag, 1);
    nFlds = length(flds_to_remove);
    for i = 1:nFlds
        fld_i = flds_to_remove{i};
        if isfield(S, fld_i)
            S = rmfield(S, fld_i);
        elseif errorIfFieldMissing
            error('Struct does not have this field : %s', fld_i)
        end
                
    end


end