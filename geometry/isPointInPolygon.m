function inside = isPointInPolygon(P, polygon)
% Point-In-Polygon algorithm (adapted from C-code from): http://alienryderflex.com/polygon/
%
% P is a point [x;y];
% polygon is a polygon: [x1 x2 x3 x4; y1 y2 y3 y4]

    Nsides = size(polygon,2);
    j = Nsides;

    oddNodes = false;

    for i = 1:Nsides
        if (polygon(2,i)< P(2) && polygon(2,j) >= P(2)) ...
            ||  (polygon(2,j)< P(2) && polygon(2,i) >= P(2))

            if (polygon(1,i) + (P(2)-polygon(2,i))/(polygon(2,j)-polygon(2,i))*(polygon(1,j)-polygon(1,i)) < P(1))
                oddNodes = ~oddNodes;
            end
        end
        j = i;
    end

    inside = oddNodes;
end