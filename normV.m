function s = normV(X, dim)
    if nargin == 1
        s = sqrt(sum(X(:).^2));  % faster just to use norm for this case, though.
    else
%         if length(size(X)) > 2
        s = sqrt(  sum(X.^2, dim)  );
    end
end

% function s = norm(X, dim)
%     if nargin == 1
%     else
%         s = sqrt(sum(X, dim).^2);
%     end
% end