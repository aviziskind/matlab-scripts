function [idx_lo, idx_hi, idx_DC, idx_nyquist] = getFourierHiLoIdxs(n, isFftShifted)
    if nargin < 2
        isFftShifted = 0;
    end
    
    if ~isFftShifted
        idx_DC = 1;
        if odd(n)
            idx_nyquist = [];
        
            idx_lo = 2 :  1  : (n+1)/2;
            idx_hi = n : -1  : (n+1)/2 + 1;
            
        else
            idx_nyquist = n/2 + 1;
            
            idx_lo = 2 :  1  : n/2;     % = idx_nyquist -1 
            idx_hi = n : -1  : n/2 + 2; % = idx_nyquist + 1
            
        end
        
        
    elseif isFftShifted

        
        
        
    end
    

end