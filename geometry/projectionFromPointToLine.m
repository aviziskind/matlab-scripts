function Q = projectionFromPointToLine(A, B, P)
    
%     AB = B-A;
%     AP = P-A;
%     t = dot(AB, AP) / (norm(AB)^2);    
%     Q = A + t*AB;
    A = A(:); B = B(:); P = P(:);

    Q = A + sum((B-A).*(P-A)) / (norm(B-A)^2)*(B-A);


end