function disp_debug(s)
    global dbug;
    if ~isempty(dbug) && dbug
        disp(s);
    end
end