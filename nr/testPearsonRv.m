function testPearsonRv

    doR = 1;
    doRho = 1;
    doTau = 1;

    doWithoutPval = 1;    
    doWithPval = 1;
    
    L = 8;
    N = 50000;    
    
    X1 = randn(L,N);
    X2 = randn(L,N);    
    
    pvals = {'without', 'with'};
    names = {'r', 'rho', 'tau'};    
    doTests = [doR, doRho, doTau];
    doPvals = [doWithoutPval, doWithPval];

    for p_i = find(doPvals)
    
        switch pvals{p_i}
            case 'without', calcP = 0;
            case 'with',    calcP = 1;
        end        
        
        for ti = find(doTests);
            switch names{ti}
                case 'r',   func_single = @pearsonR; func_multiple = @pearsonR_v;
                case 'rho', func_single = @spearmanRho; func_multiple = @spearmanRho_v;
                case 'tau', func_single = @kendallTau; func_multiple = @kendallTau_v;
            end
                
            if ~calcP
                tic;
                ccs1 = zeros(1,N);
                for i = 1:N
                    ccs1(i) = func_single(X1(:,i), X2(:,i));
                end
                t1 = toc;
                tic;
                ccs2 = func_multiple(X1, X2);
                t2 = toc;    
                assert(isequal(ccs1, ccs2));    
            else
                tic;
                ccs1 = zeros(1,N);
                pvals1 = zeros(1,N);
                for i = 1:N
                    [ccs1(i), pvals1(i)] = func_single(X1(:,i), X2(:,i));
                end
                t1 = toc;
                tic;
                [ccs2, pvals2] = func_multiple(X1, X2);
                t2 = toc;    
                assert(isequal(ccs1, ccs2));                                    
                assert(isequal(pvals1, pvals2));                                    
            end
                                
            fprintf('%s (%s pvals) : %.2f times faster\n', names{ti}, pvals{p_i}, t1/t2); 
        end
        
    end
    
end
