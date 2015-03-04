function [groups group_inds] = continuousGroupings(A, excludePoints)
    % [groups group_inds] = continuousGroupings(A)
    % groups the integers in the vector A into continuous (consecutive)
    % groups.
    % returns a cell array 'groups' , with each cell containing a vector
    % with a continuous group.
    % group_inds can also be obtained, with the indices to the original
    % vector A.
    % if a second input, 'breakpoints', is supplied, this is taken as
    % (1) a list of indices to exclude from A, for elements that are
    % integers (2) for elements that are not integers, these are taken as
    % breakpoints that divide up groups. (eg 6.5 will divide up the group
    % [4,5,6,7,8,9] into [4,5,6] and [7,8,9].  7 would divide that group
    % into [4,5,6] and [8,9].
    
    if any(mod(A, 1) ~= 0)
        error('A must contain integers');
    end
    if ~isvector(A)
        error('A must be a vector');
    end
    if nargin > 1      
        for p = excludePoints(:)'
            A(A == p) = [];
        end                    
        
        breakPoints = excludePoints( mod(excludePoints,1) ~= 0);
        isEffBreakPoint = arrayfun(@(bp) any(A == floor(bp)) && any(A == ceil(bp)), breakPoints);
        breakPoints = breakPoints(isEffBreakPoint);        
    else
        breakPoints = [];
    end
    
    A = A(:);
    if ~issorted(A)
        [B A_indices] = sort(A);
    else
        B = A;
        A_indices = 1:length(A);
    end        
    dB = diff(B);

    skipInds = find(dB > 1);
    if isempty(breakPoints)
        breakInds = [];
    else
        breakInds = binarySearch(B, breakPoints, 0, -1);
    end
    
    groupBoundaryInds = joinVectors(skipInds, breakInds);    
    
    nGroups = length(groupBoundaryInds) + 1;
    groupBoundaryInds = [0; groupBoundaryInds(:); length(B)];
    
    groups = cell(nGroups,1);
    if nargout > 1
        group_inds = cell(nGroups,1);
    end
    for gi = 1:nGroups                
        B_inds = floor(groupBoundaryInds(gi))+1  :  ceil(groupBoundaryInds(gi+1));
        
        groups{gi} =  B(B_inds);
        if nargout > 1
            group_inds(gi) = {A_indices(B_inds)};
        end
    end
    
end

function c = joinVectors(a, b)
    a_empty = isempty(a);
    b_empty = isempty(b);
    if ~a_empty && ~b_empty
       c = unique([a(:); b(:)]);
    elseif ~a_empty
       c = a(:);
    else 
       c = b(:);
    end
end

%         groups(gi) = {groupBoundaries(gi)+1:groupBoundaries(gi+1)};
