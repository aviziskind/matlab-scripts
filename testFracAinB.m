function testFracAinB

%     f = @fracAinB;
    f = @fracAinB_MATLAB;
    N = 10000;

    w01 = [0 1];
    % test single window inputs
    for i = 1:N
        w = sort(rand(1,2));
        assert( f(w01, w) == diff(w));
        assert( f(w, w01) == 1);
    end
        
    % test multiple window inputs
    n = 50;
    for i = 1:N
        w = sort(rand(n,2),2);
        assert( all (f(w01, w) == diff(w, 1, 2)) );
        assert( all (f(w, w01) == 1 ));
    end
    


end