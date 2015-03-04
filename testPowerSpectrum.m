function testPowerSpectrum

    N = 1024;
    
    A1 = 5;
    A2 = 8;
    C = 2;
    freq1_rad = 2;
    freq2_rad = 3;
    phi1 = rand*2*pi;
    phi2 = pi/4;
%     t_start = 0;
    t =4*[0:N-1]/N;

    y = A1*sin(2*pi*freq1_rad*t + phi1)+A2*cos(2*pi*freq2_rad*t+phi2)+C;

%     y = y.* gaussian(t, mean(t), 5.8);
    figure(15); clf; hold on;
    
    plot(t,y);
    
    [freqs, pows, phases] = powerSpectrum(t, y);

    figure(16);
    plot(freqs, pows, 'o-')
    drawVerticalLine([freq1_rad, freq2_rad]);
    xlim([0 4]);
    3;

    
 





end