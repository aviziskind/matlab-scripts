function h = plotX(h, data, varargin)
    dim = size(data, 1);
    
    if dim == 2
        if h == 0
            h = plot(data(1,:), data(2,:));
        else 
            set(h, 'XData', data(1,:), 'YData', data(2,:));
        end
    elseif dim == 3
        if h == 0
            h = plot3(data(1,:), data(2,:), data(3,:));
        else 
            set(h, 'XData', data(1,:), 'YData', data(2,:), 'ZData', data(3,:));
        end
    end
    
    if nargin > 2
        set(h, varargin{:});
    end    
    
end

