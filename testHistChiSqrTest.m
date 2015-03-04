function testHistChiSqrTest

%     s = 6;
%     rand('state', s); randn('state', s);
    
    nData = 50;
    alpha = .05;
    nBins = 10;
    xEdges = linspace(0, 1, 11);
    xCent = binEdge2cent(xEdges);
    dx = diff(xCent(1:2));
    xCentS = [xCent(:)', xCent(end)+dx] - dx/2;
    X = rand(nData, 1);
    X = randn(nData, 1)/5+.5;
    X(X<0) = [];
    X(X>1) = [];
    nData = length(X);
    
    N = histcnt(X, xEdges);
    N_exp = ones(nBins,1)*(nData/nBins);
    N_exp_tmp = N_exp([1:end, end]);
    figure(1); clf;
    bar( xCent , N); hold on;
    stairs( xCentS, N_exp_tmp, 'r');
    
    [h1,p1] = histChiSqrTest(N, N_exp, alpha)
    
    [h2,p2] = chi2gof(X, 'edges', xEdges, 'expected', N_exp)    
    
    
    
end



