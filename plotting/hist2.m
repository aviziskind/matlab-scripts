function h = hist2(vals_C, binArg, varargin)
%     nSets = length(vals_C);
    if nargin < 2 || isempty(binArg)
        binArg = 20;
    end

    if nargin < 3
        varargin{1} = 'stacked';
    end

    normalize = any(strcmp(varargin, 'norm'));
    doStacked = any(strcmp(varargin, 'stacked'));
    doStairs = any(strcmp(varargin, 'stairs'));
    doLine = any(strcmp(varargin, 'line'));
    cumulative = any(strcmp(varargin, 'cum'));
    
    vals_C = cellfun(@(x) x(:), vals_C, 'un', 0);

    allLims = lims(cat(1, vals_C{:}));
    
    if isscalar(binArg)
        if binArg >= 1
            nBins = binArg;
            binE = linspace(allLims(1), allLims(2), nBins+1);
        elseif binArg < 1 
            dBin = binArg;
            binE = floor(allLims(1)/dBin)*dBin : dBin : ceil(allLims(end)/dBin)*dBin;
        end
            
    elseif isvector(binArg)
        binE = binArg;        
    end
    binC = binEdge2cent(binE);
    
    
    binVals_C = cellfun(@(v) histcnt(v, binE), vals_C, 'un', 0);
    if normalize
%         binVals_C = cellfun(@(V) V/(sum(V)*diff(binE(1:2))), binVals_C, 'un', 0);
        binVals_C = cellfun(@(V) V/sum(V), binVals_C, 'un', 0);
    end
    if cumulative
        binVals_C = cellfun(@(V) cumsum(V), binVals_C, 'un', 0);
        if normalize 
            binVals_C = cellfun(@(V) min(V, 1), binVals_C, 'un', 0);
        end
        3;
    end
    
    binVals = [binVals_C{:}];
    
    if doStacked
        h = bar(binC, binVals, 1, 'stacked');
        colormap(summer);        
        
    elseif doStairs
%         bar(binC, binVals, 1); hold on;
        h = stairsBin(binC, binVals);
%         stairsBin
        
    elseif doLine
        h = plot(binC, binVals, 's-');
        
    end
    xlim(binE([1, end]));

end


function h = stairsBin(binC,y)
    binE = binCent2edge(binC(:));
    binE = [binE(1); binE; binE(end)];
    n = size(y,2);
    y_ext = [zeros(1,n); y; y(end,:); zeros(1,n)];
    h = stairs(binE, y_ext);

end