function cc = crossCorrelation(y1input, y2input)

    if iscell(y1input) && iscell(y2input) %% allow for cell inputs, where can have different x values.
        [x1, y1] = elements(y1input);
        [x2, y2] = elements(y2input);
%         if (length(x1) ~= length(x2)) || any(x1 ~= x2)
            
            % We assume they both have the same beginning point. but can have
            % different end points.
            % if both have same endpoints, use whichever one has more points.
            if (y1(end) > y2(end)) || (y1(end) == y2(end) && (length(y1) > length(y2)))
                y2 = interp1(x2, y2, x1, 'spline');  % y2  now corresponds to x1;
            else
                y1 = interp1(x1, y1, x2, 'spline');  % y1  now corresponds to x2;
            end
%         end

    else
        y1 = y1input;
        y2 = y2input;
    end

    if any( [all(y1 == 0), all(y2 == 0) ])
        cc = NaN;
        return;
    end
            
    
    y1 = y1(:)-mean(y1(:));
    y2 = y2(:)-mean(y2(:));

    cc = dot(y1,y2)/(norm(y1)*norm(y2) + eps);
end