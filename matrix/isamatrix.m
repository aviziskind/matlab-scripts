function tf = isamatrix(A)
    % returns true if A is a matrix of at least 2 columns and at least 2
    % rows.
    sizeA = size(A);
    tf = (length(sizeA) == 2) && all(sizeA >= 2);
end
