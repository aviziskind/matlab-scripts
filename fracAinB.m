function f = fracAinB(A, B)    
    if isvector(A) && isvector(B)
        % A = [A1 A2];  B = [B1 B2];
        overlap = [ max([A(1) B(1)]), ...
                    min([A(2) B(2)]) ];
        f = (rectified(overlap(2)-overlap(1))) /(A(2)-A(1));
        return;

    elseif isamatrix(A) && isvector(B)
        lenA = size(A,1);
        f = zeros(lenA, 1);
        for i = 1:lenA
            f(i) = fracAinB(A(i,:), B);
        end
        % A = [A1a A2a; A1b A2b];  B = [B1 B2];
%         lenA = size(A,1);
%         overlap = [ max([ A(:,1),  repmat(B(1), lenA, 1) ], [], 2), ...
%                     min([ A(:,2),  repmat(B(2), lenA, 1) ], [], 2) ];
%         f = (rectified(overlap(:,2)-overlap(:,1))) ./ (A(:,2)-A(:,1));
        
    elseif isvector(A) && isamatrix(B)
        % A = [A1 A2];  B = [B1a B2b; B1b; B2b];
        lenB = size(B,1);
        f = zeros(lenB, 1);
        for i = 1:lenB
            f(i) = fracAinB(A, B(i,:));
        end
%         lenB = size(B,1);
%         overlap = [ max([repmat(A(1), lenB, 1), B(:,1) ], [], 2), ...
%                     min([repmat(A(2), lenB, 1), B(:,2) ], [], 2); ];
%         f = (rectified(overlap(:,2)-overlap(:,1))) /(A(2)-A(1));
    end
end