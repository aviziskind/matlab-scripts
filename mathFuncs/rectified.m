function xrec = rectified(x)
    xrec = x .*(x >=0);
        
end

%{ 
other (slightly less efficient) implementations:

% (a)
    xrec = zeros(size(x)); 
    tf = (x >=0); 
    xrec(tf) = x(tf);

% (b)
    xrec = x;
    xrec(x<0) = 0;        

%}