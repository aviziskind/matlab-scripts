function P = getBinaryPermutations(n,m, outputType)

    if ~(m < n)
        error('m must be < n');
    end
    
    if nargin < 3
        outputType = 'number';
    end
    
    % find all combinations of m 1's in n digits
    Nperms = nchoosek(n,m);   
    
    P = zeros(Nperms,n);
    v = nchoosek([1:n], m);
    
    for i = 1:size(v,1)
        P(i,v(i,:)) = 1;
    end
    
    if strcmpi(outputType, 'char');
        P = num2str(P);
    end
    
end
