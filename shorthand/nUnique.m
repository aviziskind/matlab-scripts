function nU = nUnique(C)
    if ~iscell(C)
        C = num2cell(C);
    end
    nU = 0;
    
    for i = 1:length(C)
        found_i = false;
        for j = i+1 :length(C) 
            if isequal(C{i}, C{j})
                found_i = true;
                break
            end
        end
        if ~found_i 
            nU = nU+1;
        end
    end

    
end