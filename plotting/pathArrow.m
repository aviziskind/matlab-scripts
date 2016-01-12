function varargout = pathArrow(x, y, n)
    if nargin < 3
        n = 1;
    end
    B = length(x);
    if mod(B,n) == n-1,
        B = B-1;
    end
    A = n-1;
    if A == 0
        A = 1;
    end
        
    xdata = x(A:n:B);  
    ydata = y(A:n:B);
    udata = diff([x(A:n:B); x(A+1:n:B+1)], 1, 1);
    vdata = diff([y(A:n:B); y(A+1:n:B+1)], 1, 1);
    
    if nargout <= 1
        h = quiver(xdata, ydata, udata, vdata, 'Autoscale', 'off');
        if nargout == 1
            varargout = {h};
        end
    elseif nargout == 4
        varargout = {xdata, ydata, udata, vdata};
    end
        
end