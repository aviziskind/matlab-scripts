function [s, allCombos] = getCombo(allCombos, idx)

    nSets = length(allCombos);
    for set_i = 1:nSets
        if ~iscell(allCombos{set_i})
            allCombos{set_i} = num2cell(allCombos{set_i});
        end
        if isnumeric(allCombos{set_i}(1))
            allCombos{set_i} = cellnum2cellstr(allCombos{set_i});
        end
    end
    nEachSet = cellfun(@length, allCombos);
    nTot = prod(nEachSet);
    idx = mod(idx-1, nTot)+1;
    
    sub_idxs = ind2subV(nEachSet, idx);
    
    s_C = cell(1,nSets);
    for si = 1:nSets
        s_C{si} = allCombos{si}{sub_idxs(si)};
    end
    s = [s_C{:}];                
                
end