function Y2 = gaussSmooth(Y1, w, dim, circularFlag, leaveOutCenterFlag)
    if (w == 0)
        Y2 = Y1;
        return;
    end
    
    is_vec = isvector(Y1);
    if is_vec
        Y1 = Y1(:);
    else
        if ~exist('dim', 'var') || isempty(dim)
            dim = 1;
        end
        sizeY1 = size(Y1);
        Y1 = permuteReshapeData(Y1, dim); 
    end
    
    N = size(Y1, 1);
    n_std_gaussians = 4; % how many std deviations of gaussian to actually implement
    n_g = max(ceil(n_std_gaussians*w), 2); 
    
    circularSmooth = exist('circularFlag', 'var') && ~isempty(circularFlag);
    leaveOutCenter = exist('leaveOutCenterFlag', 'var') && ~isempty(leaveOutCenterFlag) && leaveOutCenterFlag;
    
    g = gaussian(-n_g:n_g, 0, w);
    if leaveOutCenter
        g(n_g+1) = 0;
    end
    g = g/sum(g);

    
    if circularSmooth        
        idx_pre  = mod([N-n_g+1:N]-1, N)+1;
        idx_post = mod([1:n_g]-1, N)+1;  
%         Y1 = [Y1(idx_pre); Y1; Y1(idx_post)];
        Y1 = [Y1(idx_pre,:); Y1; Y1(idx_post,:)];
    else
%         Y1 = [bsxfun(@times, ones(n_g, 1), rowsOfX(Y1, 1)); 
%               Y1; 
%               bsxfun(@times, ones(n_g, 1), rowsOfX(Y1, N))]; 
        Y1 = [ones(n_g, 1) * Y1(1,:); Y1; ones(n_g, 1) * Y1(N,:)];
    end
    
    N = round(length(g)/2);
    N2 = length(g)-N;

    Y2 = myConv(Y1, g, 1);
    N_y2 = size(Y2,1);
    
    idx = [n_g + N  :  N_y2-N2-n_g];
    Y2 = Y2(idx,:);
    
    if ~is_vec        
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
