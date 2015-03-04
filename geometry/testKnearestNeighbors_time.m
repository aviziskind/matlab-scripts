function testKnearestNeighbors_time(N_extrap)
    
%     N = 100;
%     D = 43*4;
    D = 80;
    K = 15;
    
    kNN = @(X) kNearestNeighbors(X,K);

    Ns = [180:1:280];
    if nargin < 1        
%         N_extrap = 1000000;
        N_extrap = 17000;
    end
    funcHelper = @(N) rand(D,N);
    extrapolateProcessingTime(Ns, N_extrap, kNN, funcHelper);
    
    
end

