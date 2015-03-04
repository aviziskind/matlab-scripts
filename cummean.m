function B = cummean(A, dim)
    if ndims(A) > 2
        error('only for matrices')
    end;
    if nargin < 2
        dim = find(size(A) > 1, 1);
    end    
    if dim == 2
        A = A';
    end
    B = cumsum(A, 1);
    B = bsxfun(@rdivide, B, [1:size(A,1)]' );
    if dim == 2
        B = B';
    end
end
