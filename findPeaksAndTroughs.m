function [Xs, vals] = findPeaksAndTroughs(xs, ys, zs, threshold)

    dbug = true;
    
    if nargin < 4
        threshold = 0.3;
    end
    
    nlevels = 12;
    C = contourc(zs, nlevels);
    Nx = length(xs);
    Ny = length(ys);
    assert( all(size(zs) == [Ny, Nx]));

    % get List Of Separate Contour Lines
    contourHeights = [];
    ind = 1;
    contourInds = [];
    while ind < size(C,2)
       contourHeights(end+1) = C(1,ind); %#ok<AGROW>
       contourInds(end+1) = ind; %#ok<AGROW>
       ind = ind + C(2,ind)+1;
    end
    contourInds(end+1) = ind;  % add the index of the end of the array
    nContours = length(contourHeights);
           

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    contourPoly = @(ci)   C(:,contourInds(ci)+1 : contourInds(ci+1)-1);
    
    function tf = isClosedContour(ci)
        tol = 1e-3;
        c = contourPoly(ci);
        tf = ( norm( c(:,1) - c(:,end) ) < tol);
    end

    function tf = isInside(c1, c2)
        % is contour1 inside contour2 ?
        % since the contours do not overlap, we can just pick any point on
        % contour1, and see whether it lies inside contour2
        assert(c1 ~= c2);
        contour1 = contourPoly(c1);
        contour2 = contourPoly(c2);
        tf = isPointInPolygon(contour1(:,1), contour2);
    end

    function X = centerPointOfContour(ci)
        c = contourPoly(ci);
        X = mean(c, 2);
    end

    function drawContour(ci, col)
        c = contourPoly(ci);
        line(c(1,:), c(2,:), 'Color', col);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    innerMostContours = [];
    for ci = 1:nContours
        % for each closed contour, check whether any other contours are inside it:
        % if not, put it in the array 'innerMostContours'.
        if ~isClosedContour(ci)
            isInner = false;
        else
            isInner = true;
            for cj = setdiff(1:nContours, ci)
                if isInside(cj, ci)
                    isInner = false;
                    break;
                end
            end
        end

        if isInner
            innerMostContours = [innerMostContours ci]; %#ok<AGROW>
        end
    end

    if dbug
        figure;
        contour(xs, ys, zs, nlevels);
        figure; clf; hold on;
        for ci = 1:nContours
            if isClosedContour(ci)
                drawContour(ci, 'b');
            else
                drawContour(ci, 'g');
            end
        end
        for ci = 1:length(innerMostContours)
            drawContour(innerMostContours(ci), 'r'); hold on;
            X = centerPointOfContour(innerMostContours(ci));
            plot(X(1), X(2), 'r.');
        end
    end

    function v = findPeakValueWithinContour(ci)
        % Determine whether contour is at a maxima or minima
        % (by comparing average of function at contour vs. average of
        % function inside contour)
        meanOnContour = contourHeights(ci);

        innerPointIndices = findAllPointsInContour(ci);
        meanInContour = mean(zs(innerPointIndices));

        if meanOnContour > meanInContour   % local minima
            v = min(zs(innerPointIndices));
        else
            v = max(zs(innerPointIndices));
        end

    end
    

    function inds = findAllPointsInContour(ci)
        tf = -ones(size(zs'));   % -1: unknown.  0: outside.  1: inside
        c = contourPoly(ci);
        [start_x, start_y] = elements( round(centerPointOfContour(ci)) );

        function searchAround(x,y)
            if (tf(x,y) ~= -1),     return;         end
            if ~isPointInPolygon([x;y], c);
                tf(x,y) = 0;
                return;
            else
                tf(x,y) = 1;
            end
            if (x > 1),    searchAround(x-1, y);   end
            if (x < Nx),   searchAround(x+1, y);   end
            if (y > 1),    searchAround(x, y-1);   end
            if (y < Ny),   searchAround(x, y+1);   end
        end
        searchAround(start_x, start_y);
        inds = find(tf(:) == 1);
    end


    % find the peaks and troughs.
    innerContourHeights = contourHeights(innerMostContours);
    H = max( abs( innerContourHeights ) );
    significantContours = innerMostContours ( abs(innerContourHeights)/H > threshold ); 
   
    Xs = zeros(2,length(significantContours));
    vals = zeros(1,length(significantContours));
    xs_ind = 1:Nx; 
    ys_ind = 1:Ny; length(ys);
    for sc_i = 1:length(significantContours)
        XsUnitFrame = centerPointOfContour(significantContours(sc_i));
        Xs(:,sc_i) = [interp1(xs_ind, xs, XsUnitFrame(1)); interp1(ys_ind, ys, XsUnitFrame(2))];
        vals(sc_i) = findPeakValueWithinContour(significantContours(sc_i));
    end
    
    if dbug
        for i = 1:length(Xs)
            plot(Xs(1,i), Xs(2,i), 'ks');
        end
    end
    

end