function X = permuteReshapeData(X, dim, reverseSizeX)
% 
%{
-- Permutes X such that dimension 'dim' becomes dimension #1, then Reshapes X such that 
   all columns are strung along dimension 2.
-- Can invert this transformation.

For use with a function F that needs to be able to operate on multi-dimensional arrays.
Sometimes it is convenient to be able to assume that when passing input to function F,
(1) the function will operate along the first dimension, and
(2) there are only two dimensions.
For an arbitrary n-dimensional matrix X, this function rearranges the 
dimensions such that dimension 'dim' is now dimension 1, and all the
'multi-dimensional columns' are simply strung along dimension 2. Now you
can pass the result to F, which can operate on a 2D matrix,
along dimension 1. After the F is called, you will want to undo the 
transformation (reverse the permutation, and reshaping). So you call 
this function again with the appropriate arguments to reverse the transformation.

Example
X1 = rand(5,4,8,4);
dim = 3;
you want to be able to call Y1 = F(X1), and have F operate along dimension 3
but F is designed to only operate on 2D matrices, and only operates on dimension 1.

Thus, you do the following:
X2 = permuteReshapeData(X1, dim)
Y2 = F(X2);
Y1 = permuteReshapeData(Y2, dim, size(X1));

note: alternatively, if you can edit function F yourself, you could 
incorporate this function into F (at the beginning and the end, to 
make F more versatile)
%} 
%     error(nargchk(2,3,nargin));
    
    doReverse = (nargin == 3);
    if ~doReverse  % first time        
        d = ndims(X);    

        % 1. permute;
        if (dim ~= 1)
            permOrder = [dim, 1:dim-1, dim+1:d];
            X = permute(X, permOrder);     % forward: re-arrange so that dimension 'dim' is now dimension #1.                                           
        end
        
        % 2. reshape;
        sizeX = size(X);
        n1 = sizeX(1); ncols = prod(sizeX(2:end));        
        if d > 2
            X = reshape(X, [n1, ncols]);                
        end
        
    else
        sizeX = reverseSizeX;        
        d = length(sizeX);    
        permOrder = [dim, 1:dim-1, dim+1:d];

        sizeX = sizeX(permOrder);
        n1 = size(X,1);

        % 1. invert reshape;
        if d > 2
            X = reshape(X, [n1, sizeX(2:end)]);                
        end
        
        % 2. invert permute;
        if (dim ~= 1)            
            X = ipermute(X, permOrder);     % reverse: re-arrange so that dimension 1 is now back to dimension 'dim' 
        end
        
    end    
        
    
    
    
    % forward: re-arrange so that X is now n1 x ncols 
    % reverse: re-arrange so that X is now back to original dimensions
    % (Except perhaps dimension dim)
                                           % dimension 1 is now back to dimension 'dim' 
    
%     if multiple_dims
%         Y = reshape(Y, [n1, sizeX(2:end)]);
%     end    
    
    
    
end

        
        
        
    
    
        


%     doReverse = nargin >= 3;
%     if ~doReverse  % first time
%         sizeX = size(X);
%         n1 = sizeX(1); ncols = prod(sizeX(2:end));
%         permuteFunc = @permute;
%         reshapeDims = [n1, ncols];
%     else
%         sizeX = reverseSizeX;
%         n1 = size(X,1);
%         permuteFunc = @ipermute;
%         reshapeDims = [n1, sizeX(2:end)];
%     end    
%     
%     d = length(sizeX);    
%     if (dim ~= 1)
%         permOrder = [dim, 1:dim-1, dim+1:d];
%         X = permuteFunc(X, permOrder);     % forward: re-arrange so that dimension 'dim' is now dimension #1.                                           % reverse: re-arrange so that dimension 1 is now back to dimension 'dim' 
%     end
%     
%     multiple_dims = d > 2;
%     if multiple_dims
%         X = reshape(X, reshapeDims);                
%     end