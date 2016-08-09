function testGaussSmooth 

    rng(2);
    Y = rand(1,100) + [1:100]/100*3;
%     for i = 1:40
        w = 5;
        Y_sm          = gaussSmooth(Y, w, 1,  0); 
        Y_sm_circ     = gaussSmooth(Y, w, 1,  1); 

        Y_sm_fft      = gaussSmooth(Y, w, 1,  0, 1); 
        Y_sm_circ_fft = gaussSmooth(Y, w, 1,  1, 1); 
%     end
    
    %%
    figure(1); clf;
    subplot(1,2,1);
    plot(Y, 'b.-');
    hold on;
    plot(Y_sm, 'r.-')
    plot(Y_sm_fft, 'go-')
    title('Regular');
    legend('Orig', 'Conv', 'FFT', 'location', 'best')

    subplot(1,2,2);
    plot(Y, 'b.-');
    hold on;
    plot(Y_sm_circ, 'r.-')
    plot(Y_sm_circ_fft, 'go-')
    legend('Orig', 'Conv', 'FFT', 'location', 'best')
   
    title('Circular');
    3;
    %%
    return;
    X = 1;

    t1 = 0:.01:10;
    f1 = zeros(size(t1));
    for i = 1:length(t1)
        f1(i) = myfunc(t1(i));
    end
    function f = myfunc(t)
        f = 0;    
        if t < 1
            f = 0;
        elseif t < 2
            f = (t-1);
        elseif t < 3
            f = 1;
        elseif t < 4
            f = (4-t);
        elseif t < 5
            f = 0;
        elseif t < 6            
            f = 1;
        elseif t < 7.5
            f = 3;
        else
            f = 2;
        end
    end

    function f = myfunc2(t)
        f = 0;    
        if t >= 5
            f = 1;
        end
    end
    t2 = 0:.1:20;
    f2 = zeros(size(t2));
    for i = 1:length(t2)
        f2(i) = myfunc2(t2(i));
    end

    if X == 1
        figure(1); clf;
        plot(t1,f1); hold on;
        plot(t1, gaussSmooth(f1, 10), 'r')
    elseif X == 2    
        figure(1); clf;
        plot(t2,f2); hold on;
        plot(t2, gaussSmooth(f2, 10), 'r')
    end

    
    
    %     n = 20;
%     g = gaussian(-3*n:3*n, 0, n);
%     N = round(length(g)/2);
%     N2 = length(g)-N;
%     g = g/sum(g);
%     f2 = conv(f, g);    
%     idx = [N:length(f2)-N2];
%     plot(t, f2( idx ), 'r');

end













