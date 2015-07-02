function Y2 = gaussSmooth_nu(X, Y1, w, dim)
    % gaussian smoothing function for non-uniform x
    if (w == 0)
        Y2 = Y1;
        return;
    end
    
    if ~isvector(X)
        error('X input must be a vector');
    end
    X = X(:)';
        
    is_column_vec = iscolumn(Y1); 
    if ~is_column_vec 
        if ~exist('dim', 'var') || isempty(dim)
            dim = 1;
        end
        sizeY1 = size(Y1);
        Y1 = permuteReshapeData(Y1, dim); 
    end

    Y2 = zeros(size(Y1));
    
    [N, m] = size(Y1);
    n_std_gaussians = 4; % how many std deviations of gaussian to actually implement
    max_dist = n_std_gaussians*w;
    
%     n_g = max(ceil(n_std_gaussians*w), 2); 
    
%     g = gaussian(-n_g:n_g, 0, w);
%     g = g/sum(g);

        
    for i = 1:N

        idx_start = find(X(i)-max_dist <= X, 1, 'first');
        idx_end   = find(X(i)+max_dist >= X, 1, 'last');
        idxs = idx_start:idx_end;
        assert( all( abs(X(idxs)- X(i)) <= (max_dist* (1 + 1e-5)) ))
        wgts = gaussian( X(idxs), X(i), w);
        wgts = wgts(:)/sum(wgts);
        
        Y2(i,:) = sum( Y1(idxs,:) .* wgts(:, ones(1,m) ), 1 ) ;
        
    end
    
    
    
%     N = round(length(g)/2);
%     N2 = length(g)-N;
% 
%     Y2 = myConv(Y1, g, 1);
%     N_y2 = size(Y2,1);
%     
%     idx = [n_g + N  :  N_y2-N2-n_g];
%     Y2 = Y2(idx,:);
%     
    if ~is_column_vec 
        Y2 = permuteReshapeData(Y2, dim, sizeY1);         
    end
    
end


% function Y = myConv(X, c)
% 
%     sizeX = size(x);
%     [L, ncols] = size(X);
%     rshp = length(size(X)) > 2;
%     Ly = L+length(c)-1;
%     
%     if rshp        
%         X = reshape(X, [L, ncols]);                
%     end
%     
%     Y = convmtx(c(:),L)*X;
% 
%     if rshp
%         Y = reshape(X, [Ly, sizeX(2:end)]);
%     end    
%     
% end

% function Y = rowsOfX(X, rowIdx)
%     [n, ncols] = size(X);
%     sizeX = size(X);
%     X = reshape(X, [n, ncols]);
%     Y = X(rowIdx, :);
%     Y = reshape(Y, [length(rowIdx), sizeX(2:end)]);
% end
