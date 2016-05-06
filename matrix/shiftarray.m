function Y = shiftarray(X, shiftAmounts, shiftDims, blankValue)
    
   if nargin < 4
       blankValue = 0;
   end
   if isnumeric(blankValue)
       Y = zeros(size(X), 'like', X) + blankValue;
   elseif isa(blankValue, 'function_handle')
       Y = blankValue(size(X));
   end
   
   nDims = ndims(X);
   idx_x = repmat({':'}, 1, nDims);
   idx_y = idx_x;
   
   
   assert(length(shiftAmounts) == length(shiftDims))
   for i = 1:length(shiftAmounts)
       shiftDim = shiftDims(i);
       shiftAmount = shiftAmounts(i);
   
       dimSize = size(X, shiftDim);

       if abs(shiftAmount) >= dimSize
           return
       end

       if shiftAmount >= 0
           idx_x{shiftDim} = 1:(dimSize-shiftAmount);
           idx_y{shiftDim} = shiftAmount+1 : dimSize;
       elseif shiftAmount < 0;
           idx_x{shiftDim} = -shiftAmount+1 : dimSize;
           idx_y{shiftDim} = 1:(dimSize+shiftAmount);
       end
   
   end
   Y(idx_y{:}) = X(idx_x{:});
    
end