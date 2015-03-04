function testGetF1oDC

    dt = .01;
    t = 0:dt:2*pi;
    nT = length(t);
    a = 1;
    T = 2*pi/a;

    showPlots = true;
    
    % sine wave - (simple cell response)
    f = sin(a*t)+1e-5;
    fprintf('* Sine wave (should be ~inf):');
    F1oDC = getF1oDC(t, f, T);
    disp(F1oDC);
    if showPlots
        figure(654); clf;
        subplot(4,1,1);
        plot(t,f);
    end
    
    % rectified sine wave (simple cell response)
    f = rectified(sin(a*t));
    fprintf('* Rectified sine wave (should be pi/2 ~ 1.57):');
    F1oDC = getF1oDC(t, f, T);
    disp(F1oDC);
    if showPlots
        subplot(4,1,2);
        plot(t,f);
    end

    % delta function  (simple cell response)
    f = zeros(size(t));
    f(1) = 2/dt;
    fprintf('* Delta function (should be 2):');
    F1oDC = getF1oDC(t, f, T);
    disp(F1oDC);
    if showPlots
        subplot(4,1,3);
        plot(t,f);
    end

    % random response (not a simple cell response)
    f = rand(size(t));
    fprintf('* Random Response (should be ~0):');
    F1oDC = getF1oDC(t, f, T);
    disp(F1oDC);
    if showPlots
        subplot(4,1,4);
        plot(t,f);
    end

    
    % test matrix calculation
%     N = 100;
%     f = rand(N, nT);
%     fprintf('* Testing matrix calculation...');
%     F1oDC_1 = getF1oDC(t, f, T);
%     F1oDC_2 = zeros(N,1);
%     for i = 1:N
%         F1oDC_2(i) = getF1oDC(t, f(i,:), T);
%     end
%     assert( isequal( F1oDC_1, F1oDC_2) );
%     disp(' ok');
    

end