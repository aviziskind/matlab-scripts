function str = toOrderedList(x, nMax, sep, maxRunBeforeAbbrev)
    if nargin < 2 || isempty(nMax)
        nMax = length(x);
    end
    nMax = min(nMax, length(x));
    x = x(1:nMax);

    if nargin < 3 || isempty(sep)
        sep = '_';
    end
    
    if nargin < 4 || isempty(maxRunBeforeAbbrev)
        maxRunBeforeAbbrev = 2;
    end
    
%     if nargin < 5 || isempty(abbrevSepAll)
%         abbrevSepAll = 'thq';
%     end
%     
%     if length(abbrevSepAll) >= 1
%         abbrevSepWhole = abbrevSepAll(1);
%     else
%         abbrevSepWhole = 't';
%     end
%     if length(abbrevSepAll) >= 2
%         abbrevSepHalf = abbrevSepAll(2);
%     else
%         abbrevSepHalf = 'h';
%     end
%     if length(abbrevSepAll) >= 3
%         abbrevSepQuarter = abbrevSepAll(3);
%     else
%         abbrevSepQuarter = 'q';
%     end
    
%     useHforHalfValues = exist('useHforHalfValues_flag', 'var') && isequal(useHforHalfValues_flag, 1);
    
    specialSepValues = [1, 0.5, 0.25, 5, 10];
    specialSeparators = 'thqfd';
    useHforHalfValues = 1;
        
    if isnumeric(x)
        
        
        curIdx = 1;
        str = toStr(x(1), useHforHalfValues);
        while curIdx < nMax 
            runLength = 0;
            initDiff = x(curIdx+1) - x(curIdx);
            curDiff = initDiff;
            while (curIdx+runLength < nMax) && (curDiff == initDiff)
                runLength = runLength + 1;
                if curIdx+runLength < nMax
                    curDiff = x(curIdx+runLength+1) - x(curIdx+runLength);
                end
            end
            % print('run = ', runLength)
            if runLength >= maxRunBeforeAbbrev 
                % print('a');
                % print( 't' .. x(curIdx+runLength) )
                
                abbrevSep = switchh(initDiff, specialSepValues, [num2cell(specialSeparators), sprintf('t%st', num2str(initDiff))]  );
                str = [str abbrevSep toStr(x(curIdx+runLength), useHforHalfValues)];
                curIdx = curIdx + runLength+1;
            else
                % print('b');
                % print( table.concat(x, sep, curIdx, curIdx+runLength) )
                if runLength > 0
                    str = [str sep toList(x(curIdx+1 : curIdx+runLength), [], sep)];    
                end
                curIdx = curIdx + runLength+1;
            end       
            if curIdx <= nMax 
                str = [str  sep  toStr(x(curIdx), useHforHalfValues)];
            end
        end
       
    end
        
    

end

function s = toStr(x, useHforHalfValues)
    if x == round(x)
        s = sprintf('%d', x);
    else
        s = sprintf('%.1f', x);
    end
    if useHforHalfValues 
        s = strrep(s, '.5', 'H');
    end
    
    s = strrep(s, '-', 'n');
    
end


