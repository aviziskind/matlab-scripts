function x = bound(x, L, U)
    % this is a tidy way to restrict the value of x to be within the bounds [L, U]
    % instead of the rather messy (& harder to read, and using a max & min
    % function):
    %    x = min(max(x, L), U)
    % use this function:
    %    x = bound(x, L, U)
    % or (equivalently)
    %    x = bound(x, [L U])    
    
    if nargin < 3
        U = L(2);
        L = L(1);
    end
    x(x < L) = L;
    x(x > U) = U;
end