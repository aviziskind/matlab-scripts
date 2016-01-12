function S = mergeStructs(varargin)
    S = varargin{1};
    for struct_i = 2:nargin
        S_i = varargin{struct_i};
    
        flds = fieldnames(S_i);
        for fld_j = 1:length(flds)
            S.(flds{fld_j}) = S_i.(flds{fld_j});
        end    
    end
end