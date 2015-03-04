function cs = circStd(r, phi)
    if nargin < 2
        n = length(r);
        phi = linspace(0, 2*pi, n+1);
        phi(end) = [];
        phi = reshape(phi, size(r));
    end

    phi_mean = circMean(r, phi);
    
    phi_diff = abs(phi-phi_mean);
    phi_diff = min(phi_diff, 2*pi-phi_diff);
    
    cs = sqrt( sum((phi_diff .^2) .* r) / sum(r) );    
    
end