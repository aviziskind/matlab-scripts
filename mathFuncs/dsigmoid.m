function ds = dsigmoid(x, M, w, x50)
%     if nargin < 4
%         n = 1;
%     end    
%     expnxc = exp(-n .* (x-c));
    zeroCenter = false;
    
    e = exp(-(x-x50)/w);
    ds = (M/w)* e ./ (1+e).^2;
    if zeroCenter
        ds = 2*ds;
    end
end