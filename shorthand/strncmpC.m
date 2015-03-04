function tf = strncmpC(A, B, n)
    csA = iscellstr(A);
    csB = iscellstr(B);

    if (csA && csB) || (~csA && ~csB)
        tf = strncmp(A, B, n);
    elseif csA && ~csB
        tf = cellfun(@(s) strncmp(s,B,n), A);
    elseif ~csA && csB
        tf = cellfun(@(s) strncmp(A,s,n), b);
    end
        
end