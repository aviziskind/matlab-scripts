function s = vec2csslist(v)
% converts a cell-array of strings to a comma-separated string list.
    s = cellstr2csslist( cellfun(@num2str, num2cell(v), 'un', 0));
end
