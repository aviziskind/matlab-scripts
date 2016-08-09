function test_xcorr_nonorm
    
    x = rand(1,100); y = rand(1,10); 
    n = 300;

    tic;
    for i = 1:n
        [c2, l2] = xcorr_nonorm_MATLAB(x,y, [], [], 1);
    end
    t1 = toc;
    
    
    tic;
    for i = 1:n
        [c1, l1] = xcorr_nonorm(x,y, [], 1);
    end
    t2 = toc;
    

    
    assert(isequal(c1, c2));
    assert(isequal(l1, l2));

    fprintf('%.1f times faster\n',  t1/t2); 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end