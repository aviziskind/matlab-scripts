function testPearsonR

    % test single/double
    L = 8;
    X1_s = single(randn(L, 1));
    X2_s = single(randn(L, 1));    
    
    X1_d = double(X1_s);
    X2_d = double(X2_s);
    
    cc_dd = pearsonR(X1_d, X2_d);
    cc_ss = pearsonR(X1_s, X2_s);
    cc_sd = pearsonR(X1_s, X2_d);
    cc_ds = pearsonR(X1_d, X2_s);
    
    ccs = [cc_dd, cc_ss, cc_sd, cc_ds];
    dccs = bsxfun(@minus, ccs, ccs');
    
    assert(all(dccs(:) == 0));
    
    
%     return;
    doR = 1;
    doRho = 0;
    doTau = 0;

    doWithoutPval = 1;    
    doWithPval = 1;
    
    L = 8;
    N = 1000;    
    
    pvals = {'without', 'with'};
    names = {'r', 'rho', 'tau'};    
    doTests = [doR, doRho, doTau];
    doPvals = [doWithoutPval, doWithPval];

    % test & compare multiple vector handling
    
    X1_d = single(randn(L, N));
    X2_d = single(randn(L, N));   
    
    for p_i = find(doPvals)
    
        switch pvals{p_i}
            case 'without', calcP = 0;
            case 'with',    calcP = 1;
        end        
        
        for ti = find(doTests);
            switch names{ti}
                case 'r',   func_single = @(x,y) pearsonR(x,y); func_multiple = @(x,y) pearsonR(x,y,1);
                case 'rho', func_single = @spearmanRho; func_multiple = @spearmanRho_v;
                case 'tau', func_single = @kendallTau; func_multiple = @kendallTau_v;
            end
                
            if ~calcP
                tic;
                ccs1 = zeros(1,N);
                for i = 1:N
                    ccs1(i) = func_single(X1_d(:,i), X2_d(:,i));
                end
                t1 = toc;
                tic;
                ccs2 = func_multiple(X1_d, X2_d);
                t2 = toc;    
                assert(isequal(ccs1, ccs2));    
            else
                tic;
                ccs1 = zeros(1,N);
                pvals1 = zeros(1,N);
                for i = 1:N
                    [ccs1(i), pvals1(i)] = func_single(X1_d(:,i), X2_d(:,i));
                end
                t1 = toc;
                tic;
                [ccs2, pvals2] = func_multiple(X1_d, X2_d);
                t2 = toc;    
                assert(isequal(ccs1, ccs2));                                    
                assert(isequal(pvals1, pvals2));                                    
            end
                                
            fprintf('%s (%s pvals) : %.2f times faster\n', names{ti}, pvals{p_i}, t1/t2); 
        end
        
    end
    3;
    
end
