function [S, methodId] = compress(X, methodId)
    % this function is for quickly compressing a large matrix of zero or positive values which 
    % satisfies (1) is mostly zeros (or has many zeros), and/or (2) has a limited number of possible values. 
    % (Any matrix can be input, but the compression will be most efficient with one or more of these
    % criteria).
    % Depending on which method would require the least space, the algorithm chooses between
    %    (a) storing only the lists of indices for each non-zero values (together with
    %           a list of the corresponding non-values), or 
    %    (b) storing the indices of all values, along with
    %          the corresponding original values (this helps save space because the original values 
    %          might be of double precision (8 bytes), but the indices might be only uint8 (1 byte)).    
%     % note: the matlab 'sparse' function only works on 1D or 2D arrays, and

    firstGetNonZeros = false;
    n_total = numel(X);     
    n_nonzero = nnz(X);
    if (n_total > 1e6) && (n_nonzero / n_total < .25)  % for VERY large matrices, get memory errors with 'unique' function on X, so do this more manually.
        firstGetNonZeros = true;
        idx_nonzeros = find(X);
        origDims = size(X);
        X = X(idx_nonzeros);
    end        
        
    [uVals, uValsLists, uValCounts] = uniqueList(X(:));   
    nUVals = length(uVals);
    [classRequired_idxFullX, nBytes_idxFullX] = intTypeForLength( n_total );
    valCounts = cellfun(@length, uValsLists);
    
    if ~firstGetNonZeros
        [~, mostCommonValIdx] = max(uValCounts);
        mostCommonVal = uVals(mostCommonValIdx);
        lessCommonValsIdxs = [1:mostCommonValIdx-1, mostCommonValIdx+1:nUVals];
        n_LessCommon = n_nonzero;
    else
        mostCommonVal = 0;
        lessCommonValsIdxs = 1:nUVals;
        n_LessCommon = sum( valCounts(lessCommonValsIdxs) );
    end
    
%     idxFirstNonZeroVal = find(uVals ~=0, 1);        
    
    [classRequired_idxUvalsX, nBytes_idxUvalsX] = intTypeForLength( length(uVals) );
     
    
    n_bytes_cellArrayHeader = 60;
    n_bytes_origClassType = class2nbytes(class(X));
    
    nBytesRequiredForLists    = (n_LessCommon * nBytes_idxFullX + n_bytes_cellArrayHeader*(length(uVals)-1)) + (nUVals * n_bytes_origClassType);
    nBytesRequiredForIndexing = (n_total * nBytes_idxUvalsX) + (nUVals * n_bytes_origClassType);    
    nBytesOriginal            = n_total * n_bytes_origClassType;
    nBytes_eachOption = [nBytesRequiredForLists, nBytesRequiredForIndexing, nBytesOriginal];
    
    
    if nargin < 2
         methodId = indmin(nBytes_eachOption);
    end
        
    inputIsSparse = issparse(X);
                
    if methodId == 1 % space for listing indices of non zero entries
    
        idxClassFun = str2func(classRequired_idxFullX);
        uValsLists = cellfun(idxClassFun, uValsLists, 'un', 0);                
        lists = uValsLists(lessCommonValsIdxs);
        if firstGetNonZeros
            dims = origDims;            
            lists = cellfun(@(i) cast(idx_nonzeros(i), classRequired_idxFullX), lists, 'un', 0);
        else
            dims = size(X);
            lists = uValsLists(lessCommonValsIdxs);
        end
        defaultValFields = iff(mostCommonVal ~= 0, {'defaultVal', mostCommonVal}, {});            

        doListSkips = 0;
        if (length(uVals(lessCommonValsIdxs)) == 1) 
            idx_skips = [lists{1}(1); diff(lists{1})];
            maxNSkip = max(idx_skips);
            [classRequired_skipIdxs, nBytes_skipIdxs] = intTypeForLength( maxNSkip );            
            if nBytes_skipIdxs < nBytes_idxFullX
                doListSkips = 1;
            end            
        end
        
%         doListSkips = 0;
        if ~doListSkips
            S = struct('uVals', uVals(lessCommonValsIdxs), 'uValsLists', {lists}, defaultValFields{:}, ...
                'dims', dims, 'inputIsSparse', inputIsSparse);
        else
            uValsListSkips = cast(idx_skips, classRequired_skipIdxs);
            S = struct('uVals', uVals(lessCommonValsIdxs), 'uValsListSkips', uValsListSkips, ...
                defaultValFields{:}, 'dims', dims, 'inputIsSparse', inputIsSparse);
        end
            
        3;
        
        

    elseif methodId == 2  % store indices to data values                
        X_idx = zeros(size(X), classRequired_idxUvalsX);
        for val_idx = 1:length(uVals)
            X_idx(uValsLists{val_idx}) = val_idx;
        end            
        S = struct('uVals', uVals, 'vals_idx', X_idx);
    elseif methodId == 3  % just store original matrix
        S = struct('orig_vals', X);        
    end
        

end

function [classname, nBytes] = intTypeForLength(vectorLength)
    log2_length = log2(double(vectorLength));
    if log2_length <= 8
        nBytes = 1;
    elseif log2_length <= 16
        nBytes = 2;
    elseif log2_length <= 32
        nBytes = 4;
    elseif log2_length <= 64
        nBytes = 8;
    end
    classname = ['uint' num2str(nBytes*8)];
end

function nbytes = class2nbytes(className)
    if strncmp(className, 'uint', 4)
        nbytes = str2double(className(5:end))/8;
    elseif strncmp(className, 'int', 3)
        nbytes = str2double(className(4:end))/8;
    elseif strcmp(className, 'double')
        nbytes = 8;
    elseif strcmp(className, 'single')
        nbytes = 4;
    elseif strncmp(className, 'logical', 4)
        nbytes = 1;
    end
        
end
