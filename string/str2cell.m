function c = str2cell(s)
    c = mat2cell(s, 1,ones(1,length(s)));
end