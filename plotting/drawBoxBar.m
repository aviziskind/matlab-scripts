function drawBoxBar(y, x, std_err, std_dev, col, w)
    if nargin < 6
        w = .3;
    end
    
    xl_2 = x - std_dev;
    xr_2 = x + std_dev;
    
    xl_1 = x - std_err;    
    xr_1 = x + std_err;
    
    y_u = y + w/2;
    y_d = y - w/2;
        
    patch([xl_1; xl_1; xr_1; xr_1], [y_u;  y_d;  y_d;  y_u], col);
    line([xl_2; xr_2], [y; y], 'color', 'k');
    line([xl_2; xl_2], [y_u; y_d], 'color', 'k');
    line([xr_2; xr_2], [y_u; y_d], 'color', 'k');
    
    
end