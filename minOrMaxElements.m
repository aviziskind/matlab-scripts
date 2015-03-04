function [m, indices] = minOrMaxElements(mode, X, numElements, numDimsX)

    if ~exist('numElements', 'var') || isempty(numElements)
        numElements = 1;
    end
    if ~exist('numDimsX', 'var') || isempty(numDimsX)
        numDimsX = [];
    end

    sizeX = size(X);
    if exist('numDimsX', 'var') && ~isempty(numDimsX) 
        sizeX = [sizeX, ones(1, numDimsX-length(size(X)))];  % add on singleton dimensions that were not captured with size(X)
    end

    if strcmp(mode, 'max')
        sortMode = 'descend';
    elseif strcmp(mode, 'min')
        sortMode = 'ascend';
    end
    
    [Xlist, Xinds] = sort(X(:), sortMode);
    m = Xlist(1:numElements);
    
    if nargout > 1
        ind_idxs = Xinds(1:numElements);
        indices = zeros(numElements, length(sizeX));
        for i = 1:numElements
            indices(i,:) = ind2subV(sizeX, ind_idxs(i) );
        end
    end
        

end