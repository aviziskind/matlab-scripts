function backspace(s)
    %input a string, (that has just been printed), or just the length of
    %the string, and this will erase it from the MATLAB display.    
    if ischar(s) || isempty(s)
        n = length(s);
    elseif isnumeric(s)
        n = s;
    end
    fprintf(repmat('\b', 1, n));
end