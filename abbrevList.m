function str = abbrevList(X, sep, maxRunBeforeAbbrev)
    %{ 
    concatenates items into a list
        1,4,9 -->1_4_9
    
    abbreviates sequences (containing at least 3 elements):
        1,2,3,4,5         --> 1t5     -- like MATLAB's  1:5
        1,3,5,7,9         --> 1t2t9   -- like MATLAB's  1:2:9
        1,1.5,2,2.5,3     --> 1h3     -- "h" = special separator for steps of 0.5
        1,1.25,1.5,1.75,2 --> 1q2     -- "q" = special separator for steps of 0.25 
        0,5,10,15,20      --> 0f20    -- "f" = special separator for steps of 5
        0,10,20,30,40     --> 0d40    -- "d" = special separator for steps of 10
            
    abbreviates repeated elements
        1,1,1,1  --> 1r4        -- like a special separator for steps of 0

    combines mixes of sequences:
        1,2,3,4, 8,8.5,9, 15,15,15, 20  --> 1t4_8h9_15r3_20
    
    %}    
    
    if nargin < 2 || isempty(sep)
        sep  = '_';
    end
    if nargin < 3 || isempty(maxRunBeforeAbbrev)
        maxRunBeforeAbbrev = 2;
    end

    
    abbrevSepValues = {1,    't';
                       0.5,  'h'; 
                       0.25, 'q'; 
                       5,    'f';
                       10,   'd'};

    useHforHalfValues = true;
    
    str = '';
    
    L = length(X);
    if L == 0
        return
    end
    if L == 1
        str = num2str(X);
        return
    end
            
    X_str = arrayfun(@tostring, X, 'un', 0);

    curIdx = 1;
    str = X_str{1};
    while curIdx < L 
        runLength = 0;
        initDiff = X(curIdx+1) - X(curIdx);
        curDiff = initDiff;
        
        
        while (curIdx+runLength < L) && (curDiff == initDiff) 
            runLength = runLength + 1;
            if curIdx+runLength < L 
                curDiff = X(curIdx+runLength+1) - X(curIdx+runLength);
            end
        end

        % print('run = ', runLength)
        if runLength >= maxRunBeforeAbbrev
%                 --print('a');
%                 --print( 't' .. X[curIdx+runLength] )
            if initDiff == 0 
                str = [str  'r'  num2str(runLength+1)];

            else
                abbrevSep = '';
                for j = 1:size(abbrevSepValues,1)
                    diffVal = abbrevSepValues{j,1};
                    diffSymbol = abbrevSepValues{j,2};

                    if initDiff == diffVal 
                        abbrevSep = diffSymbol;
                    end
                end


                if isempty(abbrevSep)
%                         --print(initDiff)
                    abbrevSep = sprintf('t%st', tostring(initDiff));
                end

                str = [str  abbrevSep  X_str{curIdx+runLength}];

            end
            curIdx = curIdx + runLength+1;
        else
%         --print('b');
%         --print( table.concat(X, sep, curIdx, curIdx+runLength) )
            if (runLength > 0) 
                str = [str  sep  strjoin(X_str(curIdx+1 : curIdx+runLength), sep)];
            end 
            curIdx = curIdx + runLength+1;
        end       
        if curIdx <= L 
            str = [str  sep  X_str{curIdx}];
        end
    end        


    str = strrep(str, '-', 'n');
    
    if useHforHalfValues 
        str = strrep(str, '%.5', 'H');
    end
    
end
