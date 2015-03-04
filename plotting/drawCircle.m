function h_out = drawCircle(r, O, varargin)
    if nargin < 2
        O = [0;0];
    end
    nPoints = 30;
    
    thetas = linspace(0, 2*pi, nPoints);
    h = plot(O(1) + r*cos(thetas), O(2) + r*sin(thetas), varargin{:});

    if nargout > 0
        h_out = h;
    end

end