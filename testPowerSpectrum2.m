function testPowerSpectrum

    N = 1024;
    
    A1 = 5;
    A2 = 0;
    C = 0;
    freq1_rad = 1.88;
    freq2_rad = 10;
    phi1 = rand*2*pi;
    phi2 = pi/4;
    t_start = 2.6;
    t =t_start+4*[0:N-1]/N;

    y = A1*sin(2*pi*freq1_rad*t + phi1)+A2*cos(2*pi*freq2_rad*t+phi2)+C;

    y = y.* gaussian(t, mean(t), 5.8);
    figure(15); clf; hold on;
    
    plot(t,y);
    
    [freqs, pows, phases] = powerSpectrum(t, y);

    figure(16);
    plot(freqs, pows, 'o-')
    drawVerticalLine([freq1_rad, freq2_rad]);
    xlim([0 4]);
    3;

    
    [pow_sort, idx_sort] = sort(pows, 'descend');
    
    idx_peak = idx_sort(1); %  find(pows > max(pows)/50);

    pows1 = pows(idx_peak);
    freqs1 = freqs(idx_peak);
    phases1 = phases(idx_peak);
    
    y2 = zeros(size(y));
    for i = 1:length(idx_peak)
        if idx_peak(i) == 1
            A = 1;
        else
            A = 2;
        end
        ph_i = phases1(i) - 2*pi*freqs1(i)*t_start;
        y2 = y2 + A*sqrt(pows1(i))*cos(2*pi*freqs1(i)*t  + ph_i);
                
    end
    figure(15); 
    plot(t, y2, 'g')
    
    3;
    






end