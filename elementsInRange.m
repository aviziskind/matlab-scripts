function x_out = elementsInRange(x, lims, optionFlag, inclusionFlag)
    % given a sorted list x as input, this function outputs the elements of x that
    % lie within the range(s) given by 'limits' (inclusive).
    % limits can either be in the format of an  m x 2 vector [lim(:,1), lim(:,2)], or
    % in the form of a row vector ([lim1, lim2, lim3, lim4]), delineating
    % length(lims)-1  ranges that lie between the values.
    % this function uses a binary search algorithm, which is faster than
    % MATLAB's built-in 'find' function for sorted data.

    % the following optional values for 'flag' are acceptable:
    %  -- 'rel'   : the algorithm outputs the values relative to the
    %               start of the lims window [~elements - lims(:,1)]
    %  -- 'count' : the algorithm simply outputs the *number* of elements
    %               for each range, (not the elements themselves.)
    %  -- 'index' : the algorithm provides the *indices* of the elements 
    %               that lie in each lims window (not the elements
    %               themselves).

    if ~issorted(x);
        error('Input x array must be sorted');
    end
        
    countElements = false;
    relToLims     = false;
    returnInds    = false;
    if exist('optionFlag', 'var') && ~isempty(optionFlag)
        switch optionFlag
            case 'count', countElements = true;
            case 'rel',   relToLims = true;
            case 'index', returnInds = true;
            otherwise,    error(['Unknown flag: ' optionFlag]);
        end
    end
    
    includeAtStart = true;
    includeAtEnd   = true;
    if exist('inclusionFlag', 'var') && ~isempty(inclusionFlag)        
        if strfind(inclusionFlag, '('), includeAtStart = false; end
        if strfind(inclusionFlag, '['), includeAtStart = true; end
        if strfind(inclusionFlag, ')'), includeAtEnd   = false; end
        if strfind(inclusionFlag, ']'), includeAtEnd   = true; end        
    end
    startCmp = iff(includeAtStart, @le, @lt);
    endCmp   = iff(includeAtEnd,   @le, @lt);
                
    if isvector(lims)
        if ~issorted(lims)
            warning('elementsInRange:notSorted', 'Limits variable is not sorted');
        end
        if (length(lims) > 2)  % vector format
            lims = lims(:);
            lims = [lims(1:end-1), lims(2:end)]; 
        else
            lims = lims(:)';   % make sure is a row vector;
        end
    end        
        
    nlims = size(lims,1);
    nx = length(x);
    if isempty(x)  % binary search can't handle empty matrix.
        if (countElements) 
            x_out = zeros(nlims,1);
        else
            x_out = zeros(size(x));
        end
        return;  
    end
    
    firstIndOfXinLimits = binarySearch(x, lims(:,1), -1, +1); 
    lastIndOfXinLimits  = binarySearch(x, lims(:,2), +1, -1);
    
    if ~includeAtStart
        for i = 1:nlims
            while  ( x( firstIndOfXinLimits(i) ) == lims(i,1)) && (firstIndOfXinLimits(i) < nx)
                firstIndOfXinLimits(i) = firstIndOfXinLimits(i) + 1;
            end
        end            
    end
    if ~includeAtEnd
        for i = 1:nlims
            while  ( x( lastIndOfXinLimits(i) ) == lims(i,2)) && (lastIndOfXinLimits(i) > 1)
                lastIndOfXinLimits(i) = lastIndOfXinLimits(i) - 1;
            end
        end                    
    end

    if countElements  % output # of items in each range
        x = x(:);
        emptyInds = (firstIndOfXinLimits == lastIndOfXinLimits) ...
            & ~( startCmp(lims(:,1), x(firstIndOfXinLimits)) & endCmp( x(firstIndOfXinLimits), lims(:,2)) );
   %         & ~ibetween(x(firstIndOfXinLimits), lims); ...
        
        x_out = lastIndOfXinLimits - firstIndOfXinLimits + 1;
        x_out(emptyInds) = 0;    

    else                                                   % output the elements in each range
        x_out = cell(nlims, 1);
        for li = 1:nlims
            if (firstIndOfXinLimits(li) ~= lastIndOfXinLimits(li)) ...
                    || ( startCmp(lims(li,1), x(firstIndOfXinLimits(li))) && endCmp(x(firstIndOfXinLimits(li)), lims(li,2)) )
                if relToLims                    
                    r = lims(li,1);
                else 
                    r = 0;
                end
                
                if ~returnInds
                    x_out{li} = x(firstIndOfXinLimits(li):lastIndOfXinLimits(li)) - r;
                else
                    x_out{li} = [firstIndOfXinLimits(li):lastIndOfXinLimits(li)];
                end
            end
        end
        
        if nlims == 1   % if just 1, don't output in a cell array: just have simple vector
            x_out = x_out{1};
        end        
    end
        
end





% function x_out = elementsInRange(x, lims)
%     if isempty(x)
%         x_out = [];
%         return;  % binary search can't handle empty matrix.
%     end
%     
%     start_ind = binarySearch(x, lims(1), -1, +1);
%     end_ind   = binarySearch(x, lims(2), +1, -1);
%     if (start_ind == end_ind) && ~ibetween(x(start_ind), lims)
%         x_out = [];
%     else
%         x_out = x(start_ind:end_ind);
%     end
% end