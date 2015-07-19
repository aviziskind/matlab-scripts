function [idx_K_nbrs, dist_sqr_to_nbrs] = kNearestNeighbors_Matlab(X, K)
    [m,N] = size(X);
%     assert(m < N);
    k = min(K, N-1);
    idx_K_nbrs = zeros(k,N, 'int16');
    if nargout > 1
        dist_sqr_to_nbrs = zeros(k,N);
    end
    for i = 1:N
        dists_sqr_i = sum(bsxfun(@minus, X, X(:,i)).^2, 1);

%         [k_dists, idx_K_dists] = kmin(dists_sqr_i, K+1);
%         idx_K_nbrs(:,i) = idx_K_dists(2:K+1); % idx1 = point i itself (dist = 0)
%         dist_sqr_to_nbrs(:,i) = k_dists(2:K+1);    

        [x_sorted, idx] = sort(dists_sqr_i, 'ascend');
        idx_K_nbrs(:,i) = idx(2:k+1); % idx1 = point i itself (dist = 0)
        if nargout > 1
            dist_sqr_to_nbrs(:,i) = x_sorted(2:k+1);    
        end

    end     
end
