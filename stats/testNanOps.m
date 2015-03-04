function testNanOps

% built-ins: nanmean, nanstd, nanvar

    M = 500;
    N = 600;
    X = randn(M, N);
    idx_nan = rand(M, N) < .2;
    X(idx_nan) = nan;

    testOp(@nanmean, X, 2);
    testOp(@nanvar, X, 3);
    testOp(@nanstd, X, 3);
    testOp(@nanstderr, X, 2);
    testOp(@nanmedian, X, 2);


end


function testOp(func, X, arg_id)
    if arg_id == 2
        X_all = func(X, 1);
    elseif arg_id == 3
        X_all = func(X, [], 1);
    end
    
    [M, N] = size(X);
    X_indiv = zeros(1, N);
    for i = 1:N
        X_indiv(i) = func(X(:,i));
    end
    
    assert(isequal(X_indiv, X_all));


end