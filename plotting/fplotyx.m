function fplotyx(myfunc, range, col)
    if (nargin < 3) 
        col = '-b';
    end
    dy = 0.05;
    ypoints = range(1):dy:range(2);
    xpoints = zeros(1, length(ypoints));
    for i = 1:length(ypoints)
        xpoints(i) = myfunc(ypoints(i));
    end
    plot(xpoints, ypoints, col);
end