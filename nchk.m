function err_msg = nchk(min_n, max_n, n)    
    if (n >= min_n && n <= max_n)        
        err_msg = [];        
    else
        s = inputname(n);
        if isempty(s)
            s = 'Variable';
        end        
        if (n < min_n)
            err_msg = [ s ' is too small'];        
        elseif (n > max_n)
            err_msg = [ s ' is too large'];        
        end    
    end
end
