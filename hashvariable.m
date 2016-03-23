function h = hashvariable(X)
    h = 1;
    if isstruct(X)
        fn = sort(fieldnames(X));
        for i = 1:length(fn)
            h = hashfunc(  1 +  h * hashvariable(fn{i}) * hashvariable(X.(fn{i}))  );
        end        
    elseif iscell(X)
        for i = 1:numel(X)
            h = hashfunc( 1  +  h * hashvariable(X{i}) );
        end        
    elseif ischar(X)
        h = prod( sum(X - 'A' + 1) + length(X) + 1 );
    elseif isnumeric(X)
        idx_use = ~isnan(X) & ~isinf(X) & (X ~= 0);
        h = prod( double(  1 + abs(X(idx_use)) ) );
    end
    
    h = hashfunc(h);
    assert(h ~= 0);
end

function h = hashfunc(h)
    h = (h-floor(h)) + mod(h, 2^32);
end