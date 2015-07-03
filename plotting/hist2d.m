%function mHist = hist2d ([vY, vX], yedges, xedges)
%2 Dimensional Histogram
%Counts number of points in the bins defined by yedges, xedges.
%size(vX) == size(vY) == [n,1]
%size(mHist) == [length(yedges) -1, length(xedges) -1]
%
%EXAMPLE
%   mYX = rand(100,2);
%   xedges = linspace(0,1,10);
%   yedges = linspace(0,1,20);
%   mHist2d = hist2d(mYX,yedges,xedges);
%
%   nXBins = length(xedges);
%   nYBins = length(yedges);
%   vXLabel = 0.5*(xedges(1:(nXBins-1))+xedges(2:nXBins));
%   vYLabel = 0.5*(yedges(1:(nYBins-1))+yedges(2:nYBins));
%   pcolor(vXLabel, vYLabel,mHist2d); colorbar
% function mHistOut = hist2d (mX, xBinVar, yBinVar, plotFlag)
    
function mHistOut = hist2d (X, Y, xBinVar, yBinVar, weights, plotFlag)
    % mX = fliplr(mX);
    nX = length(X);

    if length(Y) ~= nX
        error('x and y must be the same length');
    end

    if ~exist('xBinVar', 'var') || isempty(xBinVar)
        xBinVar = 10;
    end
    switch length(xBinVar)
        case 1,  %% assume input is nBinsX
            xedges = linspace(min(X), max(X), xBinVar);
        case 2,  %% assume input is [edgemin, edgemax]
            xedges = linspace(xBinVar(1), xBinVar(2), 10);
        otherwise  %% assume input is [yBinEdges]
            xedges = xBinVar;
    end     

    if ~exist('yBinVar', 'var') || isempty(yBinVar)
        yBinVar = 10;
    end
    switch length(yBinVar)
        case 1,  %% assume input is nBinsY
            yedges = linspace(min(Y), max(Y), yBinVar);
        case 2,  %% assume input is [edgemin, edgemax]
            yedges = linspace(yBinVar(1), yBinVar(2), 10);
        otherwise  %% assume input is [yBinEdges]
            yedges = yBinVar;
    end

    if ~exist('weights', 'var') 
        weights = [];
    end
    
    xedges(1) = xedges(1)-eps;    % allow for data to equal beginning of first x bin
    xedges(end) = xedges(end)+eps;
    yedges(1) = yedges(1)-eps;    
    yedges(end) = yedges(end)+eps;
    
%     nBinsTot = length(xedges) * length(yedges);
    
    
%     nRow = length (xedges)-1;
%     nCol = length (yedges)-1;

%     X = mX(:,1);
%     ydata = mX(:,2);

%     hist2D_method = @hist2D_valMethod;
%     hist2D_method = @hist2D_binMethod;
    hist2D_method = @hist2D_histcntMethod;

    mHist = hist2D_method(X, Y, xedges, yedges, weights);


    if nargout > 0
        mHistOut = mHist;
    end
    
    if (nargout == 0) && ~exist('plotFlag', 'var')
        plotFlag = 'plot';
    end
    if (exist('plotFlag', 'var') && ~isempty(plotFlag))
        hist2dPlot(mHist, xedges, yedges, plotFlag)
    end

end


function [mHist, binIds_x, binIds_y] = hist2D_histcntMethod(xdata, ydata, xedges, yedges, weights)
    %%
    haveWeights = ~isempty(weights);
    nBinX = length(xedges)-1;
    nBinY = length(yedges)-1;
        
    mHist = zeros(nBinX, nBinY);
    wgts_arg = iff(haveWeights, {weights}, {});
    
    [nMargin_x, binIds_x] = histcnt(xdata, xedges, wgts_arg{:});
    [nMargin_y, binIds_y] = histcnt(ydata, yedges, wgts_arg{:});
    
%     binIds_xy = sub2indV([nBinY, nBinX], [binIds_x, binIds_y]);
    if haveWeights
        for i = 1:length(binIds_x)
            mHist(binIds_x(i), binIds_y(i) ) = mHist(binIds_x(i), binIds_y(i) ) + weights(i);     
        end
    else
        for i = 1:length(binIds_x)
            mHist(binIds_x(i), binIds_y(i) ) = mHist(binIds_x(i), binIds_y(i) ) + 1;     
        end                
    end
    s1 = sum(mHist,1);
    s2 = sum(mHist,2);
    assert( all (abs( s1(:) - nMargin_y(:) )) < 1e-10  )
    assert( all (abs( s2(:) - nMargin_x(:))) < 1e-10  )
%     assert(isequal( sum(mHist,2)', nMargin_x))
    
end

function mHist = hist2D_valMethod(xdata, ydata, xedges, yedges)
    
    % rescale xdata & ydata
    nBinsX = length(xedges)-1;    
    nBinsY = length(yedges)-1;    
    xdata_binIds = ceil ( (xdata - xedges(1))/(xedges(end)-xedges(1))*nBinsX );
    ydata_binIds = ceil ( (ydata - yedges(1))/(yedges(end)-yedges(1))*nBinsY );
        
%     idx_toRemove = (xdata_binIds < 1) | (xdata_binIds > nBinsX) |  (ydata_binIds < 1) | (ydata_binIds > nBinsY);
%     xdata_binIds(idx_toRemove) = [];
%     ydata_binIds(idx_toRemove) = [];
%     
%     mHist = zeros(nBinsX, nBinsY);
%     for i = 1:length(xdata_binIds)
%         mHist(xdata_binIds(i), ydata_binIds(i)) = mHist(xdata_binIds(i), ydata_binIds(i)) + 1;        
%     end
%     assert(isequal(mHist, mHist2));
    
    mHist = intHist2D(xdata_binIds, ydata_binIds, nBinsX, nBinsY);
    
end

function mHist = hist2D_binMethod(xdata, ydata, xedges, yedges)
    
    for iRow = 1:nRow
        rRowLB = xedges(iRow);
        rRowUB = xedges(iRow+1);

        vColFound = vCol((vRow > rRowLB) & (vRow <= rRowUB));

        if (~isempty(vColFound))


            vFound = histc (vColFound, yedges);

            nFound = (length(vFound)-1);

            if (nFound ~= nCol)
                disp([nFound nCol])
                error ('hist2d error: Size Error')
            end

            [nRowFound, nColFound] = size (vFound);

            nRowFound = nRowFound - 1;
            nColFound = nColFound - 1;

            if nRowFound == nCol
                mHist(iRow, :)= vFound(1:nFound)';
            elseif nColFound == nCol
                mHist(iRow, :)= vFound(1:nFound);
            else
                error ('hist2d error: Size Error')
            end
        end


    end
end

