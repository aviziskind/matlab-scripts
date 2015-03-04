function A = cross2mtx(v)
    % outputs the matrix A, which, when applied to a vector x, has the same
    % effect as taking the cross product of v (the input) and x.
    % ie. A*x = cross(v,x);
    
    A = [0,   -v(3), v(2); 
         v(3), 0,   -v(1); 
        -v(2), v(1), 0  ];
end