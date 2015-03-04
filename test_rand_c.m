function test_rand_c

    rand_c('seed', 1);
    X = rand_c(10000);


    test_checks = [...
    1,  1103527590 
    2,  377401575 
    3,  662824084 
    4,  1147902781 
    5,  2035015474 
    10,  267834847
    100,  1738083805
    1000,  1219259225
    10000,  1910041713];

    for i = 1:size(test_checks,1);
        idx = test_checks(i,1);
        val = test_checks(i,2);
        
        assert(X(idx) == val);
    end



end