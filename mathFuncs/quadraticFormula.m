function [x1, x2] = quadraticFormula(a,b,c)
    sqrtdisc = sqrt(b^2-4*a*c);
    x1 = (-b + sqrtdisc)/(2*a);
    x2 = (-b - sqrtdisc)/(2*a);
end