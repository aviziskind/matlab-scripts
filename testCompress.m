function testCompress

    % test a couple of simple cases
    X = zeros(1,1000); X(10) = 1;
    [S, id] = compress(X);    
    assert(isequal(decompress(S), X));
%     assert(id == 1);
    
    X = randi(10,1, 1000);
    [S, id] = compress(X);    
    
%     assert(id == 2);
        
    X = randn(1,1000);
    [S, id] = compress(X);
    assert(isequal(decompress(S), X));
    
%     assert(id == 3);
    
    return;

    % test case with mostly zeros
    X_blank = zeros(300, 1000);
    n_tot = numel(X_blank);
    
    fracs_full = [.1:.1:.95];
    idx = randperm(n_tot);
    nPossVals = [1, 10, 300, 1000];
    progressBar('init-', length(nPossVals)*length(fracs_full));
    for i = 1:length(fracs_full)
        n_vals = round(n_tot*fracs_full(i));
        for j = 1:length(nPossVals)            
            nPoss = nPossVals(j);                        
            X = X_blank;
            X(idx(1:n_vals)) = randi(nPoss, 1, n_vals);
            testX(X);
            progressBar;
        end
    end       
    


end


function testX(X)

    Xc1 = compress(X, 1);
    Xc2 = compress(X, 2);
    Xc3 = compress(X, 3);
    Xc_auto = compress(X);
    
    Xuc1 = decompress(Xc1);
    Xuc2 = decompress(Xc2);
    Xuc3 = decompress(Xc3);
    
    assert(isequal(Xuc1, X))
    assert(isequal(Xuc2, X))
    assert(isequal(Xuc3, X))

%     Xc1_test = Xc1.uValsLists;
%     Xc1_test2 = cat(1, Xc1_test{:});
%     Xc2_test = Xc2.vals_idx;
    
    s = whos; s_names = {s.name};

%     Xc1_test_size = s(find(strcmp(s_names, 'Xc1_test'), 1)).bytes;
%     Xc2_test_size = s(find(strcmp(s_names, 'Xc2_test'), 1)).bytes;
%     Xc3_test_size = s(find(strcmp(s_names, 'Xc3_test'), 1)).bytes;
        
    Xc1_size = s(find(strcmp(s_names, 'Xc1'), 1)).bytes;
    Xc2_size = s(find(strcmp(s_names, 'Xc2'), 1)).bytes;
    Xc3_size = s(find(strcmp(s_names, 'Xc2'), 1)).bytes;
    Xc_auto_size = s(find(strcmp(s_names, 'Xc_auto'), 1)).bytes;
    
    assert(Xc_auto_size == min([Xc1_size Xc2_size Xc3_size]));
    
    
end