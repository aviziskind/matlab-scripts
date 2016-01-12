function s = cellstr2csslist(cs, sep)
% converts a cell-array of strings to a comma-separated string list.
    if nargin < 2
        sep = ', ';
    end

    if isempty(cs)
        s = '';
    elseif ischar(cs)
        s = cs;
    elseif iscell(cs);
        s = cs(:);
        s(1:length(cs)-1,2) = {sep};
        s = s';
        s = [s{:}];
    end
end
