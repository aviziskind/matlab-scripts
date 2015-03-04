% function testRadialPowerSpectrum
  
%%
    N = 30;
    x = linspace(-pi,pi,N+1); x = x(1:end-1);
    y = x;
    
    [xg, yg] = meshgrid(x,y);
    r = sqrt(xg.^2 + yg.^2);
    Z = sin(8*yg) + sin(2*xg - 2*yg) +0;
%     Z = randn(size(xg));
%     Z = Z - mean(Z(:));

    TotalE = sum(Z(:).^2);
    
    figure(56); clf;
    subplot(3,2,1);     imagesc(Z); axis equal tight;
    title({'Z = Original Image', sprintf('Total Power = %d', round(TotalE))});
    xlabel('X position'); ylabel('Y position');
    colorbar;
    colormap('gray');
    addSubplotLetter(2, 2, 1, 1, 'A');
    
    FZ = fft2(Z) / sqrt(numel(Z));
    TotalE_fft = sum(abs(FZ(:).^2));
    fftZ = abs(fftshift(FZ));
    
    subplot(3,2,2); imagesc(x, x, fftZ); axis equal tight;
    xlabel('X frequency'); ylabel('Y frequency');
    colorbar;
    title({'abs(FFT(Z))', sprintf('Total Power = %d', round(TotalE_fft))});
    addSubplotLetter(2, 2, 1, 2, 'B');
    
    TotalE_fft/TotalE
    for i = 1:2
        doAv = iff(i ==1, 0, 1);
        av_str = iff(doAv, 'averaging', 'summing');

    %     imagesc( abs(fftshift(fft2(Z))) )

    %     figure(57);
        subplot(3,2,2+i);
        [rps, rad_freqs] = radialPowerSpectrum(Z, doAv); 
        
        rad_freqs = 0:length(rps)-1;
        plot(rad_freqs, rps, 'o-');
        xlabel('Cycles Per Image');
        xlim([0, length(rps)-1]);
        title({' ', sprintf('Radial Power Spectrum (%s)', av_str), sprintf('Total Power = %d', round(sum(rps)))});
        ylabel('Power')
        addSubplotLetter(3, 2, 2, i, char('B'+i));
    end
    
    for i = 1:2
        doAv = iff(i ==1, 0, 1);
        av_str = iff(doAv, 'averaging', 'summing');

    %     imagesc( abs(fftshift(fft2(Z))) )

    %     figure(57);
        subplot(3,2,4+i);
        [aps, ang_freqs] = angularPowerSpectrum(Z, doAv); 
%         rad_freqs = 0:length(rps)-1;
        polar(ang_freqs, aps, 'o-');
%         xlabel('Cycles Per Image');
%         xlim([0, length(rps)-1]);
        title({' ', sprintf('Angular Power Spectrum (%s)', av_str), sprintf('Total Power = %d', round(sum(rps)))});
        ylabel('Power')
        addSubplotLetter(3, 2, 3, i, char('B'+i));
    end

    
    
%     assert( abs(TotalE - sum(rps)) < 1e-10)
    
    
    
    
    