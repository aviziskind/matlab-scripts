function [Q, Vcomp] = GramSchmidt(V, nColsMax)
%{
 Given a series of N column vectors (each with M elements) in V, this
 algorithm finds the M-vector orthonormal basis, (or, the first nColsMax columns of it)
 using the Gram-Schmidt algorithm.
 N can be <= M. If N < M, random vectors are used to find the
 remaining M-N basis vectors, and these are also output in Vcomp.
%}    
    function Bcomp = compAinDirOfB(A, B)    
        Bcomp = ( dot(B,A)/dot(B,B) ) * B;
    end
    
    [M,N] = size(V);
    
    if nargin < 2
        nColsMax = M;
    end
    if nColsMax > M
        error('Can''t have more than %d columns', M)
    end
    Q = zeros(M, nColsMax);
    
    if (N < nColsMax)
        V(:,N+1:nColsMax) = randn(M, nColsMax-N); %if fewer columns than N, use random vectors to find the rest.
    end
    
    for i = 1:nColsMax
        Q(:,i) = V(:,i);

        % from ith vector, remove components in directions of vectors 1 to i-1; 
        pComp = zeros(M,1);
        for j = 1:i-1
            pComp = pComp + compAinDirOfB(V(:,i), Q(:,j));
        end
        Q(:,i) = Q(:,i) - pComp;
        
        % if is close to zero, (perhaps from duplicate/almost parallel vectors), try again with a random vector;
        if norm(Q(:,i)) < 1e-3            
            Q(:,i) = randn(M,1);            
            pComp = zeros(M,1);
            for j = 1:i-1
                pComp = pComp + compAinDirOfB(Q(:,i), Q(:,j));
            end
            Q(:,i) = Q(:,i) - pComp;            
        end
    end

    for i = 1:nColsMax
        Q(:,i) = Q(:,i)/norm(Q(:,i));
    end
    
    if N < nColsMax
        Vcomp = Q(:,N+1:nColsMax);
    else
        Vcomp = [];
    end

end


%     Q(:,1) = V(:,1);
%     Q(:,2) = V(:,2) - compAinDirOfB(V(:,2), Q(:,1));
%     Q(:,3) = V(:,3) - compAinDirOfB(V(:,3), Q(:,1)) - compAinDirOfB(V(:,3), Q(:,2)) ;
%     Q(:,4) = V(:,4) - compAinDirOfB(V(:,4), Q(:,1)) - compAinDirOfB(V(:,4), Q(:,2)) - compAinDirOfB(V(:,4), Q(:,3));
