function sf = testFindStrongestFrequency

    % Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
    t = 0:.001:100;
    f = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t) + randn(size(t));

    sf = findStrongestFrequency(t,f);

end