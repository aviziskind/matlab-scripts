function testKmin

    rand('state', 0)
    X = rand(1,10000);
    
    tic;
    K = 5;
    [x_sorted, idx] = sort(X);    
    idx1 = idx(1:K);
    vals1 = x_sorted(1:K);
    t1 = toc;
    
    tic;    
    [vals2, idx2] = kmin(X, 5);
    t2 = toc;
    
    assert(isequal(idx1(:), idx2(:)));
    assert(isequal(vals1(:), vals2(:)));

    fprintf('ratio = %.2f \n', t1/t2);
    
    
end
