function y = nanrms(x, dim)
    if nargin == 1
        y = sqrt( nanmean(x.^2) );
    else
        y = sqrt( nanmean(x.^2, dim) );
    end
end