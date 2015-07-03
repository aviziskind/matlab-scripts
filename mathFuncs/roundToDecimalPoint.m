function rounded = roundToDecimalPoint(x, dec)
    p = 10^dec;
    rounded = round(x * p) / p;
end