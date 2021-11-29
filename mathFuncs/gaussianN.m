function Y = gaussianN(X, M, C)
    % size(X) = [nDims, nVars];
    % size(M) = [nDims, 1];
    % size(C) = [nDims, 1] (if diagonal) or [nDims, nDims] (for arbitrary
    %                       covariance matrix);

    if iscell(X)
        % X can be of type cell, with two matrices of co-ordinates;
        xs = X{1}; ys = X{2};
        % assert(all(size(xs) == size(ys)));
        sizeX = size(xs);
        if ~isequal(size(ys), sizeX)
            error('X and Y must be of the same size');
        end
        X_list = [xs(:) ys(:)]';
        
        Y_list = gaussianN(X_list, M, C);
        
        Y = reshape(Y_list, sizeX);
        return;
    end
    
    D = length(M);
    if ~any(size(X) == D)
        error('X must have the same dimensions as the M vector');
    end
    if (size(X,1) ~= D) && (size(X,2) == D)
        X = X';
    end
    nVars = size(X,2);
    
    if isvector(C)
        detC = prod(C);        
        Cinv = diag(1./C); % matrix with 1/C_i on the diagonal
    elseif isamatrix(C);
        detC = det(C);
        Cinv = inv(C);
    elseif isscalar(C)
        detC = C;        
        Cinv = 1/C;
    end
   
    Z = sqrt( (2*pi)^D * detC );
    X_M = bsxfun(@minus, X, M);
    
    XCX = sum( X_M .* (Cinv * X_M), 1);
    Y = (1/Z) * exp( -.5* ( XCX ) );
    

%     Y = zeros(1, nVars);
%     for i = 1:nVars
%         Y(i) = (1/Z) * exp( -.5* ( X_M(:,i)' * Cinv * X_M(:,i) ) );
%     end
                
%     p = 1./(sqrt(2*pi*sigma^2)) .* exp( -((x-mu).^2)./(2*sigma^2));
end
