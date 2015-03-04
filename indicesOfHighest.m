function ind = indicesOfHighest(data, num)
    indices = ord(data);
    ind = indices(end:-1:end-num+1);
end