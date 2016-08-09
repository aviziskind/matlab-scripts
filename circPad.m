function [X_pad, idx_central] = circPad(X, n_pad_arg, dim)


    if isvector(X) 
        nX = length(X);
        n_pad = n_pad_arg;
        circ_pad_idx = [nX - n_pad+1 : nX,   1:nX,     1:n_pad];
        idx_central = {n_pad  + [1 : nX]};

        X_pad = X(circ_pad_idx);
    elseif ismatrix(X)
        sizeX = size(X);
        
        if nargin < 3 || isempty(dim)
            dim = [1 2];
        end
            
        n_pad = [0 0];
        n_pad(dim) = n_pad_arg;

        circ_pad_idx = {[sizeX(1) - n_pad(1)+1 : sizeX(1),    1:sizeX(1),     1:n_pad(1)], ...
                        [sizeX(2) - n_pad(2)+1 : sizeX(2),    1:sizeX(2),     1:n_pad(2)]};

        idx_central = {n_pad(1) + [1 : sizeX(1)], ...
                       n_pad(2) + [1 : sizeX(2)]};
                   
        X_pad = X(circ_pad_idx{1}, circ_pad_idx{2});
    end

        
    % afterwards, to get central part of X:
    %  X_central = X_pad(idx_central{:});    
    
    
end

