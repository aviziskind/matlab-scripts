function R = NDcart2pol(X)
    % transforms each row of X to polar coordinates
    
    % input: N-D cartesian coordinates 
    %   X = [x1, x2, ..., xn];
    % output: N-D polar coordinates 
    %   R = [r, t_1, .. t_d-2, phi];  t's range is [0, pi].  phi's range is [0 2*pi]

    R = zeros(size(X));
    if isvector(X)
        X = X(:)'; % make X a row vector;        
    end
    N = size(X,1);    
    d = size(X,2);
        
    for j = 1:N
        r = norm(X(j,:));
        t = zeros(1,d-2);
        cumProdSin = r;
        for i = 1:d-2
            if cumProdSin ~= 0
                t(i) = acos(X(j,i)/cumProdSin);
                cumProdSin = cumProdSin*sin(t(i));
            end
        end    
%         phi = atan2( X(d), X(d-1) );    
        phi = atan2( X(j,d), X(j,d-1) );            
        R(j,:) = [r, t, phi];
    end
    
    
    
end


% example, with n = 5;
%   r= sqrt(x1^2 + ... + x5^2)
%   t1 = acos(x1/r)
%   t2 = acos(x2/(r*sin(t1))
%   t3 = acos(x3/(r*sin(t1)*sin(t2))
%   phi = atan2( x4, x3 )

%   t4 = acos(x4/(r*sin(t1)*sin(t2)*sin(t3))



