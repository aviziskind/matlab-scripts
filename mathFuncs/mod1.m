function y = mod1(x, n)
    y = mod(x-1, n) + 1;  % allows a number to cycle between 1 and n (without hitting zero)
end