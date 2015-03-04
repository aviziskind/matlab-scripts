function varargout = findV(X, varargin)
    sizeX = size(X);
    nDims = length(sizeX);
    inds1D = find( X(:), varargin{:});
    indsND = zeros(length(inds1D), nDims);
    for ind_i = 1:length(inds1D)
        indsND(ind_i,:) = ind2subV(sizeX, inds1D(ind_i));    
    end
    if nargout == 1
        varargout = {indsND};
    elseif nargout == nDims
        if isempty(indsND)
            varargout = cell(1, nDims);
        else
            varargout = num2cell(indsND, 1);
        end
    else
        error('Number of output arguments must be =1 or =numDimsX')
    end
        
end

