function sec = hms2sec(varargin)
    if nargin == 1
        h = 0;
        m = 0;
        s = varargin{1};
    elseif nargin == 2
        h = 0;
        m = varargin{1};
        s = varargin{2};
    elseif nargin == 3
        h = varargin{1};
        m = varargin{2};
        s = varargin{3};
    end
    sec = h*3600 + m*60 + s;
end

