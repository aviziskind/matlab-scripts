function dydt = derivative(t, y)
    if length(t) == length(y)
        dt = t(2) - t(1);
    elseif length(t) == 1
        dt = t;
    end
    if ~isvector(y)
        error('y must be a vector');
    end
    dy = diff(y(:));
    m = [ [dy(1); dy], [dy; dy(end)] ];         % this is to make dydt have same size as y(t)
    dydt = mean(m,2)/dt;
end