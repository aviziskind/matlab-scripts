function testMinElement

    N = 30;
    % basic, 1D test:
    X = rand(50,1);
    [val1, ind1] = minElement2(X, 1);
    [val2, ind2] = min(X);
    assert(val1 == val2);
    assert(ind1 == ind2);

    % simple, 2D test:
    X = round(rand(10,10));
    [val, ind] = minElement2(X);
    assert(X(ind(1), ind(2)) == val);
    
    % simple, 3D test:
    for i = 1:N
        X = rand(20,10,5);
        [val, ind] = minElement2(X);
        assert(X(ind(1), ind(2), ind(3)) == val);
    end

    % simple, 5D test:
    for i = 1:N
        X = rand(10,2,10,3,5);
        [val, ind] = minElement2(X);
        assert(X(ind(1), ind(2), ind(3), ind(4), ind(5)) == val);
    end

    % simple, 9D test:
    for i = 1:2
        X = rand(5,2,3,4,5,6,2,2,7);
        [val, ind] = minElement2(X);
        assert(X(ind(1), ind(2), ind(3), ind(4), ind(5), ind(6), ind(7), ind(8), ind(9)) == val);
    end


    % test what happens with singleton dimensions
    % 1. at the end
    for i = 1:N
        X = rand(10,5,6,1,1,1,1);
        [val, ind] = minElement2(X, 7);
        assert(X(ind(1), ind(2), ind(3), ind(4), ind(5), ind(6), ind(7)) == val);
    end
% 
    % 2. single, in position 2
    for i = 1:N
        X = rand(3,1,3);
        [val, ind] = minElement2(X);
        assert(X(ind(1), ind(2), ind(3)) == val);
    end

    % 2. single, in position 2
    for i = 1:N
        X = rand(3,1,3,3);
        [val, ind] = minElement2(X);
        assert(X(ind(1), ind(2), ind(3), ind(4)) == val);
    end
    
    % 3. two singles, in the middle
    for i = 1:N
        X = rand(3,1,1,3);
        [val, ind] = minElement2(X);
        assert(X(ind(1), ind(2), ind(3), ind(4)) == val);
    end
    
    for i = 1:N
        X = rand(3,3,1,3);
        [val, ind] = minElement2(X);
        assert(X(ind(1), ind(2), ind(3), ind(4)) == val);
    end
    
    for i = 1:N
        X = rand(5,1,5,1,5,5,1);
        [val, ind] = minElement2(X, 7);
        assert(X(ind(1), ind(2), ind(3), ind(4), ind(5), ind(6), ind(7)) == val);
    end
        










end