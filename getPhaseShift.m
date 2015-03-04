function dPhi = getPhaseShift(X, Y1, Y2, flag)
    N = length(Y1);
    if (length(Y2) ~= N)
        error('Y1 and Y2 must be the same length');
    end
    if isempty(X)
        X = 1:N;
    end
    [k1, phi1] = getSineParams(X, Y1(:));
    [k2, phi2] = getSineParams(X, Y2(:));
  
    threshold = .5;
    if exist('flag', 'var') && ((k1/k2) < threshold) || ((k2/k1) < threshold)
        dPhi = NaN;
        return;
%         error(['Y1 and Y2 have different frequencies: ( ' num2str(k1) ' and ' num2str(k2) ')']);
    end
    
    phi1_deg = phi1 *(180/pi);
    phi2_deg = phi2 *(180/pi);
    
    dPhi = abs(phi1_deg - phi2_deg);
    dPhi = min(dPhi, 360-dPhi);

end


function [k, phi] = getSineParams(x, y)
    k0 = (2*pi)* findStrongestFrequencies(x,y, 1);
    [tmp, ind0] = min( abs(x) );
    phi0 = getPhaseOfCosine(x(:), y(:), k0, x(ind0));
    
%     plot(cos(k0*x + phi0), 'go');
    f = @(beta, X) cos(beta(1)*X + beta(2));
    
    warning('off', 'stats:nlinfit:IllConditionedJacobian');
    warning('off', 'stats:nlinfit:IterationLimitExceeded')
    warning('off', 'MATLAB:rankDeficientMatrix');
    
    [k, phi] = elements( nlinfit(x,y,f,[k0 phi0]) );
%     [k, phi] = deal(k0, phi0);
%     plot(cos(k*x + phi), 'ks');
    
end