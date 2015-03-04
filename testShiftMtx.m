function testShiftMtx

    test2D = 1;
    test3D = 0;

    
    
    if test2D
        y = [1:5]';
        y_shift1 = shiftMtx_Matlab(y);
        y_shift2 = shiftMtx(y);
        
        assert(isequal(y_shift1, y_shift2));                
    end
% 
%     if test3D
%         y3 = reshape(1:20, 4, 5);
%         y3_shift1 = shiftMtx3D_Matlab(y3);
%         y3_shift2 = shiftMtx3D(y3);
%         
%         assert(isequal(y3_shift1, y3_shift2));                
%     end


end

function y2 = shiftMtx_Matlab(y)
    n = length(y);
    y2 = zeros(n,n);
    for i = 1:n
        y2(:,i) = y([i:n, 1:i-1]);
    end
end

% function y_shift = shiftMtx3D_Matlab(y)
% %     [nrows, ncols] = size(y3);
% 
%     [L, nvec] = size(y);
%     y_shift = zeros(L, ,n);
%     for i = 1:n
%         y2(:,i) = y([i:n, 1:i-1]);
%     end
%         
%     
% end