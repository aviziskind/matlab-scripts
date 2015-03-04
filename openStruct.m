function openStruct(S)
    fn = fieldnames(S);
    for i = 1:length(fn)
        evalin('caller', [fn{i} ' = S.' fn{i} ';']);
    end

end