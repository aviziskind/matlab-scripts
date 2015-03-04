function h = drawBox(UL, LR, varargin)
    [x1, y1] = elements(UL);
    [x2, y2] = elements(LR);

%     h_top    = line([x1, x2], [y1, y1]);
%     h_left   = line([x1, x1], [y1, y2]);
%     h_right  = line([x2, x2], [y1, y2]);
%     h_bottom = line([x1, x2], [y2, y2]);
% h = [h_top, h_left, h_right, h_bottom];
    
    h = patch([x1; x1; x2; x2], [y1;  y2;  y2;  y1], 'w', 'facecolor', 'none');    
    
    if nargin > 2
        set(h, varargin{:})
    end
    
end