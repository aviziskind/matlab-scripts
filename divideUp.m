function [N_segments, segment_size, points_per_segment, floors, ceilings] = divideUp(xrange, N_points, r)
    xL = xrange(1);
    xU = xrange(2);
    if nargin < 3
        r = 0;
    end
    if r < 1/N_points,
        r = 1/N_points;
    end
    % r = 1/N: num segments size is N (not very random).  [default]
    % r = 1  : num segments size is 1 (very random);

    N_segments = round( 1/r );
    segment_size = (xU-xL)/N_segments;

    points_per_segment = ceil(N_points / N_segments);  % can leave out extra ones at the end *
    floors   = xL + (0:N_segments-1)' * segment_size;
    ceilings = xL + (1:N_segments)' * segment_size;
end
