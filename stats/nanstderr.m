function s = nanstderr(x, dim)

    if nargin < 2
        dim = find(size(x) > 1, 1);
    end
    
    count = ~isnan(x);
    n = sum(count, dim);
   
    s = nanstd(x, [], dim) ./ sqrt(n);
    
end
    
% % Adapted from nanmean.m   -- this code doesn't work! (e.g., for nanstderr([1 nan])
%     
% % Find NaNs and set them to zero
% nans = isnan(x);
% x(nans) = 0;
% 
% if nargin == 1 % let sum deal with figuring out which dimension to use
%     % Count up non-NaNs.
%     n = sum(~nans);
%     n(n==0) = NaN; % prevent divideByZero warnings
%     % Sum up non-NaNs, and divide by the number of non-NaNs.
%     s = std(x) ./ sqrt(n);
% 
% else
%     % Count up non-NaNs.
%     n = sum(~nans,dim);
%     n(n==0) = NaN; % prevent divideByZero warnings
%     % Sum up non-NaNs, and divide by the number of non-NaNs.
%     s = std(x, 0, dim) ./ sqrt(n);
% end    
%     
%     
% % old code (not stable)
% %     x=x(~isnan(x));    
% %     y = stderr(x, varargin{:});    
