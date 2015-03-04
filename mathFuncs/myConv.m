function Y = myConv(X, c, dim, convShape)
    persistent cur_C cur_c cur_nx
    % - allows efficient convolution of all columns of a n-dimensional
    % array X with the vector 'c'
    % includes the option of returning only a 2-d subsection of the
    % convolution using the argument 'convShape'
    sizeX = size(X);
    if nargin < 3
        dim = find(sizeX > 1, 1);
    end    
    if nargin < 4
        sameShape = false;
    else
        switch convShape
            case 'full', sameShape = false;
            case 'same', sameShape = true;
            otherwise error('Unknown convolution shape');
        end
    end
    
    m = length(c);    
    
    X = permuteReshapeData(X, dim);
    
    n_x = sizeX(1);

    if ~isempty(cur_c) && isequal(cur_c, c) && (cur_nx == n_x)
        C = cur_C;
    else
        C = convmtx(c(:),n_x);
        cur_c = c;
        cur_C = C;
        cur_nx = n_x;
    end
        
    
    
    
    if sameShape
        idx = ceil(m/2)-1 + [1:n_x];
%         Y = Y(idx,:);
        C = C(idx,:);
    end

    Y = C*X;
    
    Y = permuteReshapeData(Y, dim, sizeX);
    
end