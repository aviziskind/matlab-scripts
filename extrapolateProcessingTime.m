function extrapolateProcessingTime(testNs, N, func, funcHelper)
    % estimates the processing time for a specific function
    % func is the function to be timed, a function of N.
    % alternatively, func takes in the output of funcHelper, which is a function of N.
    % funcHelper provides func with any additional data that is requried 
    % for calculation, but is not meant to be timed.
    %
    % Example 1 : 
    % Estimate the time to create a 10000x10000 matrix of gaussian random variables: 
    %   extrapolateProcessingTime(10:10:500, 10000, @(n) randn(n))
    %     
    % Example 2 : 
    % Estimate the time to find the inverse of a 10000x10000 matrix: 
    %   extrapolateProcessingTime(10:10:500, 10000, @(A) inv(A), @(N) rand(N,N))
    
    nTrialsPerN = 2;
    allTimes = zeros(size(testNs));
    hTs = plot(1,1, 'o-');
    hold on
    hFit = plot(1,1, 'r-');
    h_ax = gca;
    hold off
    xlim([min(testNs) max(testNs)]);

    ts = zeros(1, nTrialsPerN);
    for ni = 1:length(testNs)
        n = testNs(ni);
        for ti = 1:nTrialsPerN
            if nargin > 3
                data = funcHelper(n);
                tic;
                func(data);
                ts(ti) = toc;            
            else
                tic;
                func(n);
                ts(ti) = toc;            
            end            
        end
        allTimes(ni) = mean(ts);
        
        if ni > 10
            xs = testNs(1:ni);
            ys = allTimes(1:ni);

            xs_fit = testNs(round(ni/2):ni);
            ys_fit = allTimes(round(ni/2):ni);

            set(hTs, 'xdata', xs , 'ydata', ys);
            logx = log10(xs_fit );
            logy = log10(ys_fit );
            ply = polyfit(logx, logy, 1);
            p = ply(1);
            a = mean( ys_fit ./ (xs_fit.^p)	);
        
            timeFunc = @(x)  a * (x .^ p);
            estTimeSec = timeFunc(N);
            [fx, fy] = fplot(@(x) timeFunc(x), [1 N]);
            set(hFit, 'xdata', [fx], 'ydata', [fy], 'Visible', 'on');
            set(h_ax, 'xscale', 'log', 'yscale', 'log')
            disp(['time is ~ (' num2str(a) ')*N^' num2str(p) '. Estimated time for N = ' num2str(N) ' is ' sec2hms(estTimeSec)]);

        end
        drawnow;
    end
    3;
end

% result: 64^2 (4096): ~ 550 seconds
% result: 32^2 (1024): ~ 8 seconds
% result: 16^2 (256):  ~ .12 seconds
        
