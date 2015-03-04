function s_blnk = blankStruct(s)
    s_blnk = structfun(@(fld) [], s, 'un', 0);
end