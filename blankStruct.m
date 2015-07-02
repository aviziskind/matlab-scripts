function s_blnk = blankStruct(s, blankValue)
    if nargin < 2
        blankValue = [];
    end
    s_blnk = structfun(@(fld) blankValue, s, 'un', 0);
end