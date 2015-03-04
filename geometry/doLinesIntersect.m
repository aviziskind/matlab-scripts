function [tf, Xint] = doLinesIntersect(line1, line2)

% Algorithm by Paul Bourke (April 1989)
% http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
    % line1 = { X1, X2 } = { [x1;y1], [x2;y2] }

    X1 = line1{1}; X2 = line1{2};
    X3 = line2{1}; X4 = line2{2};
    x1 = X1(1); y1 = X1(2);
    x2 = X2(1); y2 = X2(2);
    x3 = X3(1); y3 = X3(2);
    x4 = X4(1); y4 = X4(2);
    
%     figure(65);
%     plot([x1 x2], [y1, y2], 'bo-');
%     hold on
%     plot([x3 x4], [y3, y4], 'go-');        
%     hold off
    
    num_a = (x4-x3)*(y1-y3) - (y4 - y3)*(x1-x3);
    num_b = (x2-x1)*(y1-y3) - (y2 - y1)*(x1-x3);
    denom = (y4-y3)*(x2-x1) - (x4 - x3)*(y2-y1);
    if (num_a == 0) && (num_b == 0) && (denom == 0)
        warning('lines:Intersect', 'Lines overlap');
        ua = 0;
        ub = 0;
    elseif (denom == 0)
%         warning('Lines are parallel');
        ua = 0;
        ub = 0;        
    else
        ua = num_a/denom;
        ub = num_b/denom;        
    end
        
    tf = (0 < ua) && (ua < 1) && (0 < ub) && (ub < 1);
    if nargout > 1
        Xint = X1 + ua*(X2-X1);
    end
   
end
