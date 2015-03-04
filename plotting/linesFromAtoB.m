function [X, Y, Z] = linesFromAtoB(Ax,Ay, varargin)    
    if nargin == 4
        D = 2;
        [Bx, By] = varargin{:};
    elseif nargin == 6
        D = 3;
        [Az, Bx, By, Bz] = varargin{:};
    end
    
    X = [Ax(:), Bx(:), nan(size(Ax(:)))]';
    X = X(:);
    
    Y = [Ay(:), By(:), nan(size(Ay(:)))]';    
    Y = Y(:);
    
    Z = [];
    if D == 3
        Z = [Az(:), Bz(:), nan(size(Az(:)))]';    
        Z = Z(:);
    end
    
end
