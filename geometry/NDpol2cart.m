function X = NDpol2cart(R)
    % transforms each row of R to cartesian coordinates

    % input: N-D polar coordinates 
    %   R = [r, t_1, .. t_n-2, phi];   t's range from 0 to pi. phi (= t_n-1) ranges from 0 to 2*pi  
    % output: N-D cartesian coordinates 
    %   X = [x1, x2, ..., xn];

    X = zeros(size(R));
    if isvector(R)
        R = R(:)'; % make X a row vector;        
    end
    N = size(R,1);    
    d = size(R,2);
        
    for j = 1:N
                
        r = R(j,1);
        t = R(j,2:d);
    
        cumProdSin = 1;
        for i = 1:d
            xi = r;
            if i > 1
                cumProdSin = cumProdSin*sin(t(i-1));
                xi = xi * cumProdSin;
            end
            if i < d
                xi = xi * cos(t(i));
            end            
            X(j,i) = xi;
        end
        
    end
    
end

% example, with n = 5;
%     x1 = r*cos(t1);
%     x2 = r*sin(t1)*cos(t2);
%     x3 = r*sin(t1)*sin(t2)*cos(t3);
%     x4 = r*sin(t1)*sin(t2)*sin(t3)*cos(phi);    
%     x5 = r*sin(t1)*sin(t2)*sin(t3)*sin(phi);
%     X = [x1 x2 x3 x4 x5];




%         xi = r;
%         for j = 1:n-i
%             xi = xi * sin(t(j));
%         end   
%         if i > 1
%             xi = xi * cos(t(n-i+1));
%         end            
%         X(i) = xi;





%     for i = 1:n
%         xi = r;        
%         for j = 1:i-1
%             xi = xi * sin(t(j));
%         end   
%         if i < n
%             xi = xi * cos(t(i));
%         end            
%         X(i) = xi;
%     end
