function data_filtered = fft_bandpass(samp_raw, normFreq, filter_dim)


    % odd
    n = length(samp_raw);
    samp_raw_fft = fft(samp_raw, [], filter_dim);
    
    %%
    highest_freq_idx = round(n/2);    
    freq_range = round(n*normFreq/2);
    blank_idx = [1: freq_range(1), freq_range(2):highest_freq_idx];
    
    samp_raw_fft(blank_idx) = 0;
    
    data_filtered = ifft(samp_raw_fft, [], filter_dim, 'symmetric');
    
end