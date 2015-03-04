function s = sigmoid(x, M, w, x50)
%     if nargin < 4
%         n = 1;
%     end
%     s = M./(1+exp( - n.*(x-c) ));
    zeroCenter = false;
    
    s = M./(1+exp( - (x-x50)/w) );

    if zeroCenter
        s = 2*s - M;
    end
    
    
end