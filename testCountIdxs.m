function testCountIdxs

    dims = [36 10 8 10];
    n_items = 200;

    nmax = prod(dims);
    idxs = randi(nmax, 1, n_items);
    
    B = 100;
    
    tic;    
    for b = 1:B
        X1 = countIdxs_Matlab(dims, idxs);
    end
    t1 = toc;
    
    tic;
    for b = 1:B
        X2 = countIdxs(dims, idxs);
    end
    t2 = toc;
    
    assert(isequal(X1, X2));
    fprintf('%.2f times faster\n', t1/t2)




end