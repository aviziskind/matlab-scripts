function y = odd(X)
    y = (mod(X, 1) == 0) & (mod(X, 2) ~= 0);
end