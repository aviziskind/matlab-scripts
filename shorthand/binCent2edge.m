function binEdges = binCent2edge(binCenters)
    nBins = length(binCenters);
    binCenters = binCenters(:);
    midBinEdges = mean( [ binCenters(1:nBins-1), binCenters(2:nBins) ], 2);
    
    leftEdge = midBinEdges(1)    - diff(binCenters(1:2));
    rightEdge = midBinEdges(end) + diff(binCenters(end-1:end));
    
    binEdges = [leftEdge; midBinEdges; rightEdge];
end