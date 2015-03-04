function x_filt = fastmedfilt1(x, W, dim)
% Very fast implementation of the classical 1D running median filter of
% window size W (odd). Uses a quick selection method to obtain the median
% of each sliding window. Initial and final condition vectors can also be
% specified. Avoids the need for a large sort buffer so handles very long
% window sizes efficiently.

x_filt = zeros(size(x)); 
sz = size(x);

if nargin < 3 || isempty(dim)
    dim = find(sz > 1, 1);
end

if length(sz) == 2
    m = sz(1); n = sz(2);
    
    
    if dim == 1
        for j = 1:n
            x_filt(:,j) = fastmedfilt1d(x(:,j), W);
        end        
    elseif dim == 2
        for i = 1:m
            x_filt(i,:) = fastmedfilt1d(x(i,:), W);
        end                
    end
    
else
   % add implementation for 3-d or higher matrices. 
    error('not implemented yet');
end

end