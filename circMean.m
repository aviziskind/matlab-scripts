function cm = circMean(r, phi)
    if nargin < 2
        n = length(r);
        phi = linspace(0, 2*pi, n+1);
        phi(end) = [];
        phi = reshape(phi, size(r));
    end

    s = r(:) .* sin(phi(:));
    c = r(:) .* cos(phi(:));
    cm = mod(  atan2(sum(s), sum(c)) , 2*pi);  % for 3rd/4th quadrants, atan2 returns negative answer (-pi:0), but want pi:2*pi.
    
    if nargin < 2
        dPhi = diff(phi(1:2));
        cm = (cm + dPhi) / (2*pi) * n;
        
        cm = mod(round(cm-1), n)+1; % round number between 1 and n
    end

end

