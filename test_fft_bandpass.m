function test_fft_bandpass
    
%     L = 12;
%     freq_max = L/2;
%     th = linspace(0, 2*pi, L+1);
%     th = th(1:L);
%     y1 = cos(1*th)+.2;
%     y2 = cos(6*th)+.2;
%     Y1 = fft(y1);
%     Y2 = fft(y2);
% 
%     Y2_mod = Y2;
% %     Y2_mod(5) = 0;
%     y2_mod = ifft(Y2_mod, 'symmetric');
%     3;
%     
%     
%     figure(1); plot(th, y1, 'bo-', th, y2, 'go-', th, y2_mod, 'r.:');
%     figure(2); clf; plot(1:L, real(Y2), 'bs-', 1:L, imag(Y2), 'g.:');


    L = 1000;
    y1 = randn(1, L);
    
    Y1 = fft(y1);
    
    Y1_mod = Y1;
    Y1_mod([1:40, 60:550]) = 0;
    y1_mod = ifft(Y1_mod, 'symmetric');
    
    figure(1); plot(1:L, y1, 'b', 1:L, y1_mod, 'r')
    
    3;

%     X = zeros(1, L);
%     X(7) = 1i;
%     x = ifft(X, 'symmetric');
%     figure(3); plot(x)
    

end