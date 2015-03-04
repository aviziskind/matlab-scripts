function C = getFuncVariableNames(f1)

    s = func2str(f1);
    k1 = strfind(s, '(');
    k2 = strfind(s, ')');
    s = s(k1+1:k2-1);
    commaPositions = strfind(s, ',');
    C = cell(1, length(commaPositions) + 1);
    start_idx = 1;
    end_idx = length(s);
    for i = 1:length(commaPositions)
        C{i} = s(start_idx:commaPositions(i)-1);
        start_idx = commaPositions(i)+1;        
    end
    C{end} = s(start_idx:end_idx);
    
end
