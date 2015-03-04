function str = lock_removeInvalidChars(str)
    str = strrep(str, '[', '');
    str = strrep(str, ']', '');
end

