function testGetF1phase

    showWorking = true;

    t0 = 3;
    dt = .01;
    w = 2;
    T = 2*pi/w;
    nCyc = 1;
    t = t0:dt:t0+nCyc*T;
    nT = length(t);
    
    % 1a. basic test: test that can accurately compute phase of a regular (co)sine wave 
    phi0 = 0.02:.1:2*pi;
    phi1 = zeros(size(phi0));
    for i = 1:length(phi0)
        f = cos(w*t - phi0(i));
        phi1(i) = getF1phase(t, f, T);
    end
    diff = abs(phi0 - phi1);
    diff = min(diff, 2*pi-diff);    
    assert( max(diff) < .1); % max diff is about .0125;
    if showWorking
        figure(1); plot(phi0, phi1); axis([0 2*pi, 0, 2*pi]);xlabel('actual phase'); ylabel('computed phase')
    end

    % 1b. test that can accurately compute f1 & dc of any (co)sine wave 
    A = 3;
    C = 1;
    phi0 = pi/2;%0.02:.1:2*pi;    
    f1 = A*cos(w*t - phi0)+C;
    [phi1, f_cos] = getF1phase(t, f1, T);
%     max(f1)/max(f_cos)

    if showWorking
        figure(2); clf;
        plot(t,f1, 'b', 'linewidth', 2); hold on;
        plot(t,f_cos, 'r'); 
    end
    
    % 2a. test approximation of gaussian with a sine wave of appropriate phase
    addNoise = true;
    f1 = gaussian(t, t0 + nCyc*T*.7, T/8)+ (addNoise)*randn(1,nT)/10;
    [phi1, f_cos] = getF1phase(t, f1, T);
    
    f2 = cos(w*t - phi1);
    
    if showWorking
        figure(3); clf;
        plot(t,f1, 'b', 'linewidth', 2); hold on;
%         plot(t,f2, 'g:'); 
        plot(t,f_cos, 'r'); 
        xlim([t0 t0+nCyc*T])
    end

    
    % 2b. test approximation of delta function with sine wave of appropriate phase    
    f1 = zeros(size(t));
    i = round(nT*.8);
    f1(i-20:i+10) = 1;
    f1 = f1 + (addNoise)*randn(1,nT)/10;
    [phi1, f_cos] = getF1phase(t, f1, T);
    f2 = cos(w*t - phi1);

    if showWorking
        figure(4); clf;
        plot(t,f1, 'b', 'linewidth', 2); hold on;
%         plot(t,f2, 'g:'); 
        plot(t,f_cos, 'r'); 
        xlim([t0, t0+nCyc*T])
    end
    
    
    
    
    

end