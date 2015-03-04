function [uniqueVals,count] = uniqueCount(A, varargin)
    combineNanValues = true;
        
    % Provides counts of each unique value
    if iscell(A) && ~isempty(A) && isnumeric(A{1}) && (length(A{1}) > 1)
        A = cellfun(@(x) num2str(x(:)'), A, 'Un', false);
    end    
    [uniqueVals, ind_in_A, val_idx] = unique(A, varargin{:});
    
    count = zeros(size(ind_in_A));
    for i = 1:length(val_idx)
        count(val_idx(i)) = count(val_idx(i)) + 1;
    end

    if combineNanValues && isnumeric(uniqueVals)
        nanIdxs = find(isnan(uniqueVals));
        if ~isempty(nanIdxs)
            uniqueVals(nanIdxs(2:end)) = [];
            count(nanIdxs(1)) = length(nanIdxs);
            count(nanIdxs(2:end)) = [];                     
        end        
    end
    
%     count = arrayfun(@(i) nnz(n == i), 1:length(b));    
end