function S = std_med(X, dim, rescaleToMatchGaussian_flag)
    if (nargin < 2) || isempty(dim)
        M = mean(X);
        S = sqrt( median( bsxfun(@minus, X, M).^2) );
    else
        M = mean(X, dim);
        S = sqrt( median( bsxfun(@minus, X, M).^2, dim) );
    end
    
    rescaleToMatchGaussian = nargin == 3 && rescaleToMatchGaussian_flag == 1;
    if rescaleToMatchGaussian
        S = S / 0.6745; % ratio of std_med(gaussian) / std(gaussian)
    end
end