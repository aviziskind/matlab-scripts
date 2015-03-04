function xt = trimmed(X, percent)

    X = sort(X(:));
    n = length(X);

    k = n*percent/200;
    k0 = round(k - eps(k));
    if ~isempty(n) && n>0 && k0<n/2
        xt = X((k0+1):(n-k0),:);
    else
        xt = [];
    end

end