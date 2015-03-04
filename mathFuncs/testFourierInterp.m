function testFourierInterp
    

% %     nyq = [-.2:.001:.3]; Nnyq = length(nyq);

    doBasicTest = 0;
    doNyquistTest = 0;
    doNExtTest = 0;
    doSpeedTest = 1;
    doBasicWelchTest = 0;

    if doBasicTest
        
        N = 30;
        ncols = 1;
        t = 1:N;
        M = 10;
        dt = 1/M;    
        N_ext = 20;

        t_ext = -N_ext+1:N+N_ext;
        y_ext = randn(length(t_ext), ncols);
        t_idx = N_ext + [1:N];

        t = t_ext(t_idx);
        y = y_ext(t_idx,:);

        [t_itp, y_itp] = fourierInterp(t_ext, y_ext, M, t);

        figure(1); clf;
        plot(t, y, 'bo', t_itp, y_itp, 'r.-');
        
    end
    
    if doNyquistTest
        
%         nyq = [-.02:.001:.02]; 
%         nyq = [-.1, .1]; 
        nyq = [-.3:.005:.3]; 
        Nnyq = length(nyq);
        B = 3;
        stds_F = zeros(B, Nnyq);
        stds_W = zeros(B, Nnyq);
        stds_S = zeros(B, Nnyq);
    
        N = 10;
        N_ext = 200;
        M = 5;
    
        progressBar('init-', B*Nnyq)    
    
        for nqi = 1:Nnyq
            for bi = 1:B
                progressBar;
                [s_fr, s_wl, s_spl] = doInterpTest(nyq(nqi), N, N_ext, M, []);
                stds_F(bi, nqi) = s_fr;
                stds_W(bi, nqi) = s_wl;
                stds_S(bi, nqi) = s_spl;
            end
        end        
        
        figure(4); clf;
        plot(nyq, gaussSmooth( mean(stds_F,1), 0.1), 'bo-'); hold on;
        plot(nyq, gaussSmooth( mean(stds_W,1), 0.1), 'r.-');        
        plot(nyq, gaussSmooth( mean(stds_S,1), 0.1), 'g.-');        
        xlabel('Nyquist frequency - highest frequency')
        ylabel('std dev. of error')
        legend('fourier', 'sinc', 'spline')
        3;
    end

        
    if doNExtTest
        
        N_exts = [0:20, 22:2:100]; nN_exts = length(N_exts);
        nyq = 2;
        M = 10;
        B = 50;
        stds_F = zeros(B, nN_exts);
        stds_W = zeros(B, nN_exts);
        stds_S = zeros(B, nN_exts);
    
        N = 20;    
        progressBar('init-', B*nN_exts)    
    
        for nni = 1:nN_exts
            for bi = 1:B
                progressBar;
                [s_fr, s_wl, s_spl] = doInterpTest(nyq, N, N_exts(nni), M, []);
                stds_F(bi, nni) = s_fr;
                stds_W(bi, nni) = s_wl;
                stds_S(bi, nni) = s_spl;
            end
        end        
        
        figure(5); clf;
        plot(N_exts, mean(stds_F,1), 'b.-'); hold on;
        plot(N_exts, mean(stds_W,1), 'r.-');        
        plot(N_exts, mean(stds_S,1), 'g.-');        
        set(gca, 'yscale', 'log')
        xlabel('Number of points on either side')
        ylabel('std dev. of error')
        legend('fourier', 'sinc', 'spline')
        
        3;
    end
    
    
    
    if doSpeedTest
        N = 70;
        ncols = 4;
        t = 1:N;
        M = 10;
        dt = 1/M;    
        N_ext = 80;
        B = 100;

        t_ext = -N_ext+1:N+N_ext;
        y_ext = randn(length(t_ext), ncols);
        t_idx = N_ext + [1:N];

        t = t_ext(t_idx);
        y = y_ext(t_idx,:);

        tic;
        for b = 1:B
            [t_itp, y_itp] = fourierInterp(t_ext, y_ext, M, t);
        end
        t_fourier_together = toc;
        
        
        tic;
        y_itp2 = zeros(size(y_itp));
        for i = 1:B
            for ci = 1:ncols
                [t_itp2, y_itp2(:,ci)] = fourierInterp(t_ext, y_ext(:,ci), M, t);
            end
        end
        t_fourier_separate = toc;
        
%         tic;
%         for b = 1:B
%             [t_itp, y_itp3] = fourierInterp(t_ext, y_ext, M, t, 1);
%         end
%         t_fourier_linear = toc;        

        tic;
        W = N_ext-1;
        for b = 1:B
            [t_itp, y_itpW] = sincInterp(t_ext, y_ext, M, W, t);
        end
        t_sinc = toc;        
        
        
        assert(max(abs(y_itp2(:)- y_itp(:))) < 1e-10)
%         assert(max(abs(y_itp3(:)- y_itp(:))) < 1e-10)
        assert(mean(abs(y_itpW(:)- y_itp(:))) < 1e-1)

        tic;
        for i = 1:B
            [y_itpS] = interp1(t_ext, y_ext, t_itp, 'spline');    
        end
        t_spline = toc;
    
%         fprintf('Sep/Tog : %.2f.  lin/fft : %.2f.  sinc/fft :  %.2f,  Spline/Fourier: %.2f\n', ...
%             t_fourier_separate/t_fourier_together,  t_fourier_linear/t_fourier_together,  t_sinc/t_fourier_together, t_spline/t_fourier_together)
        fprintf('Sep/Tog : %.2f.  sinc/fft :  %.2f,  Spline/Fourier: %.2f\n', ...
            t_fourier_separate/t_fourier_together,  t_sinc/t_fourier_together, t_spline/t_fourier_together)
    end

    if doBasicWelchTest

        rand('state', 0);        
        
        N = 10;
        N_ext = 21;
        M = 10;
        nq = 2;
        W = 20;
        [t, y, t_ext, y_ext, t_fine, y_fine, t_fine_ext, y_fine_ext] = getInputExample(N, N_ext, M, nq);
        
        [t_itp1, y_itp_F] = fourierInterp(t_ext, y_ext, M, t);
                
        [t_itp2, y_itp_W] = sincInterp(t_ext, y_ext, M, W, t);
        
        figure(1); clf;
        plot(t, y, 'bo', t_fine, y_fine, 'b.-', t_itp1, y_itp_F, 'gs-', t_itp2, y_itp_W, 'rd-');
        
        dF = abs(y_fine(:) - y_itp_F);
        dW = abs(y_fine(:) - y_itp_W);
        figure(2); hist( dF ); title( sprintf('%.2g', mean(dF)));
        figure(3); hist( dW ); title( sprintf('%.2g', mean(dW)));
        
        3;
    end

    
    
%     figure(1); clf;
%     plot(t, y, 'bo', t_itp, y_itp, 'r.', t_itp, y_itpS, 'g.');
    

    3;


end


function [std_fourier, std_sinc, std_spline] = doInterpTest(nq, N, N_ext, M, showFlag)

    show = exist('showFlag', 'var') && ~isempty(showFlag);
    
    [t, y, t_ext, y_ext, t_fine, y_fine, t_fine_ext, y_fine_ext] = getInputExample(N, N_ext, M, nq);

    if showFlag
        figure(1); clf;
%         plot(t_fine_ext, y_fine_ext, '.-', t_ext, y_ext, 'o', t_fine, y_fine, 'g.', t, y, 'bs'); hold on;
        h = plot(t_fine, y_fine, 'k.-'); hold on;        
        set(h(1), 'markersize', 15);
    end

%     t_idx = N_ext + [1:N];
%     y = y_ext(t_idx,:);
%     
    [t_itpF, y_itpF] = fourierInterp(t_ext, y_ext, M, t);
    W = min(max(N_ext-1, 0));
    [t_itpW, y_itpW] = sincInterp(t_ext, y_ext, M, W, t);
    
    [y_itpS] = interp1(t_ext, y_ext, t_itpF, 'spline');    

    
    if show
        plot(t_itpF, y_itpF, 'b.-');
        plot(t_itpF, y_itpS, 'g.-');
        plot(t, y, 'ko', 'markersize', 10);
%         xlim([t(1)-3, t(end)+3])
    end

    diffsF = y_itpF(:)-y_fine(:);
    diffsW = y_itpW(:)-y_fine(:);
    diffsS = y_itpS(:)-y_fine(:);
    std_fourier = std(diffsF);
    std_sinc = std(diffsW);
    std_spline = std(diffsS);
%     std_fourier = mean(abs(diffsF));
%     std_sinc = mean(abs(diffsW));
%     std_spline = mean(abs(diffsS));

    if show
        figure(2);
    
%         figure(1); clf; hist(diffs1);
%         title(sprintf('std = %.2g', std_fourier))
%         figure(2); clf; hist(diffs2);
%         title(sprintf('std = %.2g', std_spline))

    end

%     tic;
%     for i = 1:100
%         [t_itp, y_itp] = fourierInterp(t, y, 10, 1);
%     end
%     t1 = toc;
%     tic;
%     for i = 1:100
%         [y_itpS] = interp1(t_ext, y_ext, t_itp, 'spline');    
%     end
end

function [t, y, t_ext, y_ext, t_fine, y_fine, t_fine_ext, y_fine_ext] = getInputExample(N, N_ext, M, nq)

    t = 1:N;
    dt = 1/M;    

    t_ext = -N_ext+1:N+N_ext;

    t_fine_ext = -N_ext+1:dt:N+N_ext;
    y_fine_ext = zeros(size(t_fine_ext));

    t_idx = find(t_fine_ext == 1, 1) : find(t_fine_ext == N, 1);

    for i = [1:N-5]+nq
        y_fine_ext = y_fine_ext + sin(t_fine_ext*(pi)/i + rand*2*pi);
    end

    y_ext = y_fine_ext(1:M:end);
    t_ext2 = t_fine_ext(1:M:end);
    assert(isequal(t_ext, t_ext2));

    t_fine = t_fine_ext(t_idx);
    y_fine = y_fine_ext(t_idx);

    t2 = t_fine(1:M:end);
    y = y_fine(1:M:end);
    assert(isequal(t, t2));
    
end