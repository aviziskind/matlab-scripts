function p = lognormal(M, S, x)
    if (x <=0) 
        p = 0;
    else
        p =  1./(S*x*sqrt(2*pi)) .* exp( -((log(x)-M).^2)./(2*S^2));
    end
end
