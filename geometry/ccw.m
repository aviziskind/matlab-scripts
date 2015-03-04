function tf = ccw(a, b, c, negFlag)
    % returns true (1) if traversing from point a to point b to point c is
    % a counter-clockwise turn. Otherwise, returns false (0).
    nCols = [size(a,2), size(b,2), size(c,2) ];
    maxNcols = max(nCols);
    if any(nCols < maxNcols)        
        if size(a,2) == 1
            a = a*ones(1,maxNcols);
        end
        if size(b,2) == 1
            b = b*ones(1,maxNcols);
        end
        if size(c,2) == 1
            c = c*ones(1,maxNcols);
        end
    end        
        
    areas = a(1,:).*b(2,:) - a(2,:).*b(1,:) + a(2,:).*c(1,:) - a(1,:).*c(2,:) + b(1,:).*c(2,:) - c(1,:).*b(2,:);
    if (nargin > 3) && ~isempty(negFlag)
        tf = sign(areas);
    else
        tf = areas > 0;
    end
%     note:
%     if area > 0, counter-clockwise turn.
%     if area < 0, clockwise turn.
%     if area == 0, points are collinear.

end