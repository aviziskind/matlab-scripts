function Xs = randomSpread(Xrange, N_points, r)
    if nargin < 3
        r = 0;
    end

    ndim = length(N_points);
    
    if ndim == 1

        [N_segments, segment_size, points_per_segment, floors] = divideUp(Xrange, N_points, r);
        Xs = rand(N_segments, points_per_segment) * segment_size + repmat(floors, 1, points_per_segment);
        Xs = Xs(:);

    elseif ndim == 2
        
        xrange = Xrange(1,:);
        yrange = Xrange(2,:);
        Nx = N_points(1);
        Ny = N_points(2);
        
        xs = zeros(Nx, Ny);
        ys = zeros(Nx, Ny);

        for i = 1:Ny
            xs(:,i) = randomSpread(xrange, Nx, r);
        end
        for i = 1:Nx
            ys(i,:) = randomSpread(yrange, Ny, r);
        end
        Xs = [xs(:), ys(:)];

    end

end