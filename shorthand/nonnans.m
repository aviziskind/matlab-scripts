function Y = nonnans(X)
    Y = X( ~isnan(X) );
end

