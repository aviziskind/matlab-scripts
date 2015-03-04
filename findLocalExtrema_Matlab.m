function idxs = findLocalExtrema_Matlab(mnmxtype, x, w, k, firstLast)

    if (nargin < 3) || isempty(w)
        w = 1;
    end
    if nargin < 4
        k = [];
    end
    if nargin < 5
        firstLast = 'first';
    end

    n = length(x);

    prevState = 0;
    count = 0;
    prevCount = 0;
    
    switch mnmxtype 
        case 'min', searchState = 1;
        case 'max', searchState = -1;
        otherwise, error('unknown')
    end
        
    locSwitch = 0;
        
    isExtremum = false(1, n);
    nExtremaFound = 0;
    
    allIs = 1:n-1;
    di = 1;
    
    if ~isempty(k) && strcmp(firstLast, 'last')            
        allIs = n:-1:2;
        di = -1;
    end
    
    
    for i = allIs

        state = sign(x(i+di)-x(i));
%         else        
%             state = sign(x(i-di)-x(i));        
%         end
        
        if state == prevState
            count = count + 1;
        else
%             if state == +1
%             end
            prevState = state;
            prevCount = count;
            count = 1;
            locSwitch = i;            
        end
        
        if (state == searchState) && (prevCount >= w) && (count == w)
            isExtremum(locSwitch) = 1;
            nExtremaFound = nExtremaFound + 1;
            if ~isempty(k) && nExtremaFound == k
                break;
            end
        end                    
        
    end    

    idxs = find(isExtremum);
    
    if di == -1
        idxs = fliplr(idxs);
    end
    
    
end

% findLocalMaximaOrMinima