function s = strcell(c)
    % create string containing comma-separated list of strings from a
    % cell-array of strings
    c = c(:)';
    commas = [repmat({', '}, 1, length(c)-1), {''}];
    tmp = [c; commas];
    tmp = tmp(:)';
    s = [tmp{:}];
end
