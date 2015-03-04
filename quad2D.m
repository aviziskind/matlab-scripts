function q = quad2D(funxy, xlim, ylim)
    
    function qx = integralForY(y)
        funx = @(x) funxy(x,y);
        qx = quad(funx, xlim(1), xlim(2));
    end

    integralForY(ylim(1))
    integralForY(ylim(2))
    
    funx = @(x) funxy(x,ylim(1));
    q = quad(funx, xlim(1), xlim(2))
    
%     intY = @(y) integralForY(y);

%     q = quad(intY, ylim(1), ylim(2))
end