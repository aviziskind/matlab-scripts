function testKnearestNeighbors

    rand('state', 0);
    
    N = 1000;
    D = 5;
    K = 3;
    X = rand(D,N)*10;    
    
    tic;
    [idxs2, distSqrs2] = kNearestNeighbors(X,K);    
    t2 = toc;

    tic;
    [idxs1, distSqrs1] = kNearestNeighbors_Matlab(X,K);
    t1 = toc;
    
%     idxs2 = idxs2';
%     distSqrs2 = distSqrs2';
    
    assert(isequal(idxs1, idxs2));
    assert( max( abs(distSqrs1(:)-distSqrs2(:))) < 1e-3 );
    fprintf('ratio = %.2f \n', t1/t2);
    
end






% 
% function [idx_K_nbrs, dist_sqr_to_nbrs] = getKnearestNeighbors_Matlab(X, K)
%     N = size(X,2);
%     idx_K_nbrs = zeros(N,K);
%     dist_sqr_to_nbrs = zeros(N,K);
%     for i = 1:N
%         dists_sqr_i = sum(bsxfun(@minus, X, X(:,i)).^2, 1);
%         [x_kmin, idx_kmin] = kmin(dists_sqr_i, K+1);
% %         [x_sorted, idx] = sort(dists_sqr_i, 'ascend');
% %         [x_sorted, idx] = sort(dists_sqr_i, 'ascend');        
%         idx_K_nbrs(i,:) = idx_kmin(2:K+1); % idx1 = point i itself (dist = 0)
%         dist_sqr_to_nbrs(i,:) = x_kmin(2:K+1);    
%     end    
% end
% 
