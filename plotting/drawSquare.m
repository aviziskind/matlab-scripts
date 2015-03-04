function h = drawSquare(lb, ur, varargin)
    [x1, y1] = elements(lb);
    [x2, y2] = elements(ur);
    
    
    X = [x1, x1, x2, x1; 
         x1, x2, x2, x2];
    Y = [y1, y2, y1, y1;
         y2, y2, y2, y1];
    h = line(X, Y, varargin{:});

    %       
    %    B  2  C
    %    1     3
    %    A  4  D
    %
    
end
