function [r, r_vec] = pearsonRm(X)
    n = size(X,2);

    i_sub = zeros(n*(n-1)/2,2);
    I = 1;
    for i = 1:n
        for j = 1:i-1
           i_sub(I,:) = [i,j];  
           I = I+1;
        end
    end
    
    i_idx = mtxSub2ind(i_sub, n);
    j_idx = mtxSub2ind(fliplr(i_sub), n);
    
    r = eye(n);
    
    X1 = X(:, i_sub(:,1));
    X2 = X(:, i_sub(:,2));
    r_vec = pearsonR(X1, X2, 1);
    
    r(i_idx) = r_vec;
    r(j_idx) = r_vec;
    
    for i = 1:n
        for j = 1:i-1
           r(i,j) = pearsonR(X(:,i), X(:,j));
           r(j,i) = r(i,j);
        end
    end
    
    
end