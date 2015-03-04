function varargout = elements(X, indices)
    % assigns the elements of the input value X into the outputs.
    % can be used on vectors, matrices (returns columns), cells, or structs.
    %   example 1: (vector)
    %       [a,b] = elements([1, 2]);
    %   example 2: (cell array)
    %       [a,b] = elements({1; 2});
    %   example 3: (matrix)
    %       [e1, e2, e3] = elements(eye(3));
    %   example 4: (struct)
    %       [name, number] = elements(struct('Name', 'Bob', 'Number', 3));
    
    if isstruct(X)
       X = struct2cell(X);
       if size(X,3) > 1
           error('Can only handle one struct at a time');
       end
    end


    if nargin < 2
        if isvector(X)
            indices = 1:length(X);
        elseif isamatrix(X)
            indices = 1:size(X,2);
        end
    end
    
    if iscell(X)
        if isvector(X)
            for i = indices
                varargout{i} = X{i};
            end
        elseif isamatrix(X)
            for i = indices
                varargout{i} = X{:,i};
            end            
        end
    else
        if isvector(X)
            for i = indices
                varargout{i} = X(i);
            end
        elseif isamatrix(X)
            for i = indices
                varargout{i} = X(:,i);
            end            
        end
    end
end