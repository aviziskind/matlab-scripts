function [uniqueVals, inds, counts] = uniqueList(A, varargin)
    % Provides list of indices where each of the unique values occurs in the original array
    combineNanValues = true;
    
    if iscell(A) && isnumeric(A{1}) && (length(A{1}) > 1)
        A = cellfun(@(x) num2str(x(:)'), A, 'Un', false);
    end    
    [uniqueVals, ind_in_A, val_idx] = unique(A, varargin{:});
    
    nUnique = length(ind_in_A);  % don't use uniqueVals in case called with 'rows'
    
    inds = cell(1, nUnique);
    for i = 1:nUnique
        inds{i} = find(val_idx == i);
    end

    if combineNanValues && isnumeric(uniqueVals)
        nanIdxs = find(isnan(uniqueVals));
        if ~isempty(nanIdxs)
            uniqueVals(nanIdxs(2:end)) = [];
            inds{nanIdxs(1)} = [inds{nanIdxs}];
            inds(nanIdxs(2:end)) = [];
        end        
    end
    
    if nargout >= 3
        counts = cellfun(@length, inds);
    end        
    
end