function groupIdxs = multiForLoopIdxs(varargin)
    % generates a matrix for use loop indices for an arbitrary number of
    % nested for loops.
    % input : separateLoopIdxs, a cell array of indices for each separate
    %   for loop: (eg: {[1:10], [3:5], [5:5:25]}. this corresponds to 3
    %   nested for loops: i = 1:10, j = 3:5, k = 5:5:15
    % output: a matrix where each column is the indices [i;j;k] of one of
    %  the for loops. [ [1;3;5], [1;3;10], ..., [10;5;25]];

    if (nargin == 1) && iscell(varargin{1})    
        separateLoopIdxs = varargin{1};
    else
        separateLoopIdxs = varargin;
    end
    
    n_idxs = length(separateLoopIdxs);    
    nEachLoop = cellfun(@length, separateLoopIdxs);
    nTotal = prod(nEachLoop);
    
    groupIdxs = zeros(n_idxs, nTotal);    
    for idx_i = 1:n_idxs
        idxs_before = [1:idx_i-1];        
        idxs_after =  [idx_i+1:n_idxs];
        nReps = prod(nEachLoop(idxs_before));
        nEachRep = prod(nEachLoop(idxs_after));
        
        i = bsxfun(@times, ones(nEachRep, nEachLoop(idx_i)), separateLoopIdxs{idx_i});
        groupIdxs(idx_i,:) = repmat( i(:)', [1, nReps]);
    end
    
end

%{
ind = 1;
for i = 1:nEachLoop(1)
    for j = 1:nEachLoop(2)
        for k = 1:nEachLoop(3)                
            for m = 1:nEachLoop(4)
                groupIdxs(:, ind) = [i; j; k; m];
                ind = ind + 1;
            end
        end
    end
end
toc;
%}