function Z = gabor(A, mu_x, mu_y, sig_x, sig_y, theta, k, phi, C, XY) 
    % XY can be:
        % - a single co-ordinate [x;y]
        % - a list of co-oordinates [x1, x2, ... xn; y1, y2, ... yn]
        %        (in columns or rows)
    
    Xc = [mu_x; mu_y];
        	    
    % XY can be a list of co-ordinates: with row (or column) is a set of co-ordiantes;
        
    [m,n] = size(XY);
    if (m == 2)
        doTranspose = false;  % ok - keep XY as is
    elseif (n == 2)
        doTranspose = true;
        XY = XY';
    else
        error('X is not the right shape: dimensions must be mx2 or 2xn');
    end
    
    % actual gabor function;
    XYp = shiftAndRotate(XY, Xc, theta);        
    Xp = XYp(1,:);
    Yp = XYp(2,:);       
    gaborEnvelope = A .* expsqr(Xp, sig_x) .* expsqr(Yp, sig_y);
    if length(phi) == 1
        Z = gaborEnvelope .* cos( k * Xp + phi ) + C;    
    else
        %%
        nPh = length(phi);
        xplusphi = bsxfun(@plus, k*Xp(:), phi(:)' );        
        cosineModulation = cos( xplusphi );
        gaborEnvelope = gaborEnvelope(:);
        Z = gaborEnvelope(:, ones(nPh, 1)) .* cosineModulation + C;        
    end
    
    
    if doTranspose && length(phi) == 1
        Z = Z';
    end
        
    
    
end


function y = expsqr(x, sigma)  
    y = exp( -(x.^2)./(2*sigma^2));
end

% function y = expsqr(x, mu, sigma)  
%     y = exp( -((x-mu).^2)./(2*sigma^2));
% end

function Xp = shiftAndRotate(X, Xc, theta)  
    Xp = bsxfun(@minus, X, Xc);
    Xp = rotationMatrix(-theta) * (Xp);
end
    