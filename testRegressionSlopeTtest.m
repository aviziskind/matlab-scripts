function testRegressionSlopeTtest
    
    rand('state', 0);
    N = 80;
    x = linspace(0,1,N)';
    y = x * 0.3 + rand(N,1);
    alpha = .05;
%     figure(1); clf;
%     plot(x,y, '.'); hold on;
    figure(1);
    [h,p] = regressionSlopeTtest(x,y, alpha, '0', 'show');

    figure(2);
    [h,p] = regressionSlopeTtest(x,y, alpha, '-', 'show');

    figure(3);
    [h,p] = regressionSlopeTtest(x,y, alpha, '+', 'show');
    
    
end