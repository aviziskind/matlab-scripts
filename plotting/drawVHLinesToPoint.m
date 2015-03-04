function h = drawVHLinesToPoint(xypairs, varargin)
    % assume rows (mx2), or otherwise, columns (2xn)

	[m,n] = size(xypairs);
    if (n == 2) 
        [xs, ys] = elements({xypairs(:,1), xypairs(:,2)});
    elseif (m == 2)
        [xs, ys] = elements({xypairs(1,:), xypairs(2,:)});
    else
        error('X is not the right shape: dimensions must be mx2 or 2xn');
    end
        
    origAxes = axis;
    
    for i = 1:length(xs)
        hlines(i) = line([0 xs(i)], [ys(i), ys(i)]); %#ok<NASGU>
        vlines(i) = line([xs(i) xs(i)], [0, ys(i)]); %#ok<NASGU>
    end
    hnds = [hlines vlines];
    
    set(hnds, 'Color', 'k', 'LineStyle', ':', varargin{:});
    if nargout == 1
        h = hnds;
    end

    axis(origAxes); % in case line is out of bounds of original axes;
end