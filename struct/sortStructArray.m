function s2 = sortStructArray(s1, fieldnm, varargin)

    fieldvals = [s1(:).(fieldnm)];
    inds = ord(fieldvals, varargin{:});
    s2 = s1(inds);

end