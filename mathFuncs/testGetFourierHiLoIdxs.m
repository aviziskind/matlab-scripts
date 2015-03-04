function testGetFourierHiLoIdxs


    % test odd
    
    n_odd = 51;
    
    y = randn(1, n_odd);
    yf = fft(y);
    [idx_lo, idx_hi] = getFourierHiLoIdxs(n_odd);
    
    assert( all( yf(idx_lo) == conj( yf(idx_hi) ) ) );
    
%     max(abs( yf( idx_lo) - conj( yf(idx_hi) ) )) < 1e-10
    
    % test even
    
    n_even = 52;
    
    y = randn(1, n_even);
    yf = fft(y);
    [idx_lo, idx_hi] = getFourierHiLoIdxs(n_even);
    
    assert( all( yf( idx_lo) == conj( yf(idx_hi) ) ) );
    
    
    % test 2D odd:
    [idx_lo, idx_hi] = getFourierHiLoIdxs(n_odd);
    y_2D = randn(n_odd, n_odd);
    yf_2D = fft2(y_2D);
    for i = 1 : n_odd
        assert( isequalToPrecision( yf_2D(idx_lo, i),  conj( yf_2D(idx_hi, i) ), 1e-10 )  );
        assert( isequalToPrecision( yf_2D(i, idx_lo),  conj( yf_2D(i, idx_hi) ), 1e-10 )  );
    end
    
    
    

end