function testQuadProdGaussians

%     DsToTest = [1 2 3];
    DsToTest = [2];
    showScatterPlots = 0;

    for D = DsToTest 

        M1 = rand(D,1);
        M2s = ones(D,1)*[-1.5:.25:1.5];

        X1 = randn(100,D);
        X2 = bsxfun(@plus, randn(100,D), M2s(:,1)');
        C1 = cov(X1);
        C2 = cov(X2);

        if showScatterPlots
            figure(1); clf;
            switch D
        %         case 1,  
                case 2,  plot(X1(:,1), X1(:,2), 'b.', X2(:,1), X2(:,2), 'g.');
                case 3,  plot3(X1(:,1), X1(:,2), X1(:,3), 'b.', X2(:,1), X2(:,2), X2(:,3), 'g.');
            end


        end

        N = size(M2s,2);
        prod_numeric = zeros(1,N);
        prod_calculated = zeros(1,N);

        gauss1 = @(X) gaussianN(X, M1, C1);
        progressBar('init-', length(M2s))
        for mi = 1:length(M2s)
            progressBar;
            M2 = M2s(:,mi);    
            nstd = 3;
            bnd = [M1-nstd*det(C1), M1+nstd*det(C1), M2-nstd*det(C2), M2+nstd*det(C2)];
            bnd1 = min(bnd,[], 2);
            bnd2 = max(bnd,[], 2);    

            gauss2 = @(X) gaussianN(X, M2, C2);
            switch D
                case 1,  q_calc = quad(@(x) gauss1(x).*gauss2(x), bnd1(1), bnd2(1));
                case 2,  
                    f1 = @(x,y) vectorFuncHandle(gauss1, x,y);
                    f2 = @(x,y) vectorFuncHandle(gauss2, x,y);            
                    q_calc = dblquad(@(x,y) f1(x,y).*f2(x,y), bnd1(1), bnd2(1), bnd1(2), bnd2(2));
                case 3,  
                    f1 = @(x,y,z) vectorFuncHandle(gauss1, x,y,z);
                    f2 = @(x,y,z) vectorFuncHandle(gauss2, x,y,z);            
                    q_calc = triplequad(@(x,y,z) f1(x,y,z).*f2(x,y,z), bnd1(1), bnd2(1), bnd1(2), bnd2(2), bnd1(3), bnd2(3));            
            end
            prod_numeric(mi) = q_calc;    
            prod_calculated(mi) = quadProdGaussians(M1, C1, M2, C2);     

        end

        figure(10+D); clf;
        plot(M2s(1,:), prod_numeric, 'bo-', M2s, prod_calculated, 'r.:');
        legend({'Numeric', 'Analytic'}, 'location', 'best');
        title(sprintf('Test of formula in %d dimensions', D))

        % figure(11); clf;
        % plot(prod_numeric, prod_calculated, 'r.');
    end

    
    % test Log vs normal modes.
    D = 4;
    M1 = randn(D,1)-1;
    M2 = randn(D,1)+1;
    C1 = randn(D); C1 = (C1+C1')^2;
    C2 = randn(D); C2 = (C2+C2')^2;
    
    Q    = quadProdGaussians(M1, C1, M2, C2);
    logQ = quadProdGaussians(M1, C1, M2, C2, 'log');
    
    assert( abs( log(Q) - logQ ) < 1e-5);
    3;
    
end