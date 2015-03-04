function q = quadProdGaussians(M1, C1, M2, C2, outputLog_Flag, C1inv, C2inv, normalizeBySameMean_Flag)
    M1 = double(M1(:)); M2 = double(M2(:));
    C1 = double(C1); C2 = double(C2);
    D = length(M1);

    outputLog = exist('outputLog_Flag', 'var') && ~isempty(outputLog_Flag);
    haveInverses = exist('C1inv', 'var') && ~isempty(C1inv) && exist('C2inv', 'var') && ~isempty(C2inv);
    normalizeBySameMean = exist('normalizeBySameMean_Flag', 'var') && isequal(normalizeBySameMean_Flag, 1);        
    
    if haveInverses
        C1i = double(C1inv);
        C2i = double(C2inv);
    else
        C1i = inv(C1);
        C2i = inv(C2);
    end
    
    logCalcMode = outputLog;
    if ~logCalcMode  % if not outputting in log form, try calc in normal form.
        detC1 = det(C1);
        detC2 = det(C2);
        logCalcMode = isinf(detC1) || isinf(detC2);
        
        Z = 1/sqrt(((2*pi)^(2*D))*detC1*detC2);
    end        
    if logCalcMode                
        logDetC1 = logDet(C1);
        logDetC2 = logDet(C2);
        
        logZ = -D*log(2*pi) - 0.5*(logDetC1 + logDetC2);                
    end
    
    A = (C1i + C2i)/2;
    B = (M1'*C1i + M2'*C2i)'; %#ok<*MINV>
    C = -(M1'*C1i*M1 + M2'*C2i*M2)/2;
    
    invA = inv(A);        
    if outputLog
        if ~logCalcMode
            logZ = log(Z);            
        end        
        logDetInvA = logDet(invA);
        q = logZ + (.25* B'*invA'*B +C ) + D/2*log(pi) + .5*logDetInvA;
    else
        if logCalcMode
            Z = exp(logZ);
        end               
        q =  Z * exp(.25* B'*invA'*B +C ) * sqrt(pi^D * det(invA));        
    end

    
    if normalizeBySameMean
        if outputLog                        
            q_same_mean = quadProdGaussians(M1, C1, M1, C2, 1);
            q = q - q_same_mean;
        else
            q_same_mean = quadProdGaussians(M1, C1, M1, C2);
            q = q / q_same_mean;
        end
    end
    
%     if isnan(q)
%         3;
%     end
end

    
function logDetA = logDet(A)
    [L,U] = lu(A);
    s = det(L);        % This is always +1 or -1 
    signDetA = s*prod(sign(diag(U)));
    
    logDetA = sum(log(abs(diag(U))));
    if (signDetA == -1)
        logDetA = logDetA + pi*1i;
    end
end