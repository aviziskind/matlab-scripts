function inds = findInStructArray(sArray, fieldname, testvalue, evalfn)
    % syntax:
    % inds = findInStructArray(sArray, fieldname, testvalue,    evalfn)
    %      evalfn must take in 2 inputs: the 2 inputs will be: (1) field value, (2) your test value.
    %             eg. findInStructArray(movieCellGroups, 'moviesType', 'Noise', @strcmp)  
    % inds = findInStructArray(sArray, fieldname, [], evalfn)
    %      evalfn must take in 1 input: the 1 inputs will be the field value.
    %             eg. findInStructArray(movieCellGroups, 'nSpikes', [], @(x) length(x) > 4)  
    % inds = findInStructArray(sArray, fieldname, eqltestvalue)
    %             eg. findInStructArray(movieCellGroups, 'Gid', 45)  
    % inds = findInStructArray(sArray, fieldname)

    
    if isempty(sArray)
        inds = [];
        return;
    end
    
    if ~isfield(sArray(1), fieldname)
        error([ fieldname ' is not a field of the struct array'])
    end
    
    if nargin < 4        
        if nargin == 3
            if isnumeric(testvalue)
                evalfn = @isequal;
            elseif ischar(testvalue)
                evalfn = @strcmp;
            end
        else
            evalfn = @isequal;
        end
    end
    if nargin < 3
        testvalue = 0;
    end

    function rslt = evalFunctionOnStruct(s)
        actualvalue = s.(fieldname);
        if ~isempty(testvalue)
            rslt = evalfn(actualvalue, testvalue);
        else
            rslt = evalfn(actualvalue);
        end        
    end

    searchresults = arrayfun(@evalFunctionOnStruct, sArray, 'UniformOutput', false);
    evalResults = cell2mat( searchresults );
    inds = find(evalResults);
    
end