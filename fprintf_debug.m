function fprintf_debug(s)
    global dbug;
    if ~isempty(dbug) && dbug
        fprintf(s);
    end
end