function cv = circVar(r, phi)
    n = length(r);
    r = r(:);
    if nargin < 2
        phi = linspace(0, 2*pi, n+1)';
        phi(end) = [];
    end
        
%     cv = 1-sqrt( sum( r .* cos(2*phi))^2 + sum( r .* sin(2*phi))^2 )/sum(r);
    
    cosSum = sum( r(:) .* cos(2*phi(:)));
    sinSum = sum( r(:) .* sin(2*phi(:)));

    cv = 1-sqrt(cosSum^2 + sinSum^2)/sum(r);    
end 