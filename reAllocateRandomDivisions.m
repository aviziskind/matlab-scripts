function [X_new X_added] = reAllocateRandomDivisions(X_cur,  range_new, N_new, r)

    if nargin < 4
        r = 0;
    end
    
%     if size(X,2) > size(X,1)
%         X = X';
%     end

    [nCurXs ndim] = size(X_cur);
    if ndim == 1

        [N_segments, segment_size, points_per_segment, floors, ceilings] = divideUp(range_new, N_new, r);
        
%         numXsInSegments = sum(  (repmat(floors',   nCurXs, 1) < repmat(X_cur, 1, N_segments)) ...
%                               & (repmat(ceilings', nCurXs, 1) > repmat(X_cur, 1, N_segments))     , 1);
        numXsInSegments = sum(  crossOp( floors', @lt, X_cur ) & crossOp( ceilings', @gt, X_cur) , 1);

        numMissingXs = rectified(points_per_segment - numXsInSegments);
        
        X_added = cell(N_segments,1);
        for si = 1:N_segments
            X_added{si} = floors(si) + rand(numMissingXs(si), 1) * segment_size;
        end
        X_added = cell2mat(added_Xs);
            
    elseif ndim == 2
        xrange = range_new(1,:);         Nx = N_new(1);
        yrange = range_new(2,:);         Ny = N_new(2);
        
        [N_xsegments, x_segment_size, points_per_xsegment, x_floors] = divideUp(xrange, Nx, r);
        [N_ysegments, y_segment_size, points_per_ysegment, y_floors] = divideUp(yrange, Ny, r);
        points_per_box = round(mean([points_per_xsegment points_per_ysegment]));
        
        numInXYSegments = zeros(N_xsegments, N_ysegments);
%         x_bins = zeros(1, nCurXs);
%         y_bins = zeros(1, nCurXs);
        x_bins = binarySearch( x_floors, X_cur(:, 1), 0, -1) ;
        y_bins = binarySearch( y_floors, X_cur(:, 2), 0, -1) ;
        for i = 1:nCurXs
            numInXYSegments(x_bins(i), y_bins(i)) = numInXYSegments(x_bins(i), y_bins(i)) + 1;
        end
%         for xi = 1:N_xsegments
%             for yi = 1:N_ysegments
%                 numInXYSegments(xi, yi) = nnz( ( x_bins == xi) & (y_bins == yi) );
%             end
%         end
%         numInXYSegments = sum(  ...
%            (repmat(x_floors,    [1 N_ysegments nCurXs]) < repmat(xs_pole, [N_xsegments, N_ysegments])) ...
%          & (repmat(x_ceilings,  [1 N_ysegments nCurXs]) > repmat(xs_pole, [N_xsegments, N_ysegments])) ...          
%          & (repmat(y_floors',   [N_xsegments 1 nCurXs]) < repmat(ys_pole, [N_xsegments, N_ysegments])) ...
%          & (repmat(y_ceilings', [N_xsegments 1 nCurXs]) > repmat(ys_pole, [N_xsegments, N_ysegments])),  3);
            
        numMissingXs = rectified(points_per_box - numInXYSegments);
        
        X_added = cell(N_xsegments, N_ysegments);
        for xi = 1:N_xsegments
            for yi = 1:N_ysegments
                X_added{xi, yi} = [ x_floors(xi) + rand(numMissingXs(xi,yi), 1) * x_segment_size, ...
                                    y_floors(yi) + rand(numMissingXs(xi,yi), 1) * y_segment_size;  ];
            end
        end
        X_added = cell2mat(X_added(:));
        
    end
	X_new = [X_cur; X_added];        

end
